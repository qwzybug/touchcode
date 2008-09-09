//
//  CSqliteDatabase.m
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase.h"

#include <sqlite3.h>

// sqlite group_concat functionality

typedef struct {
    NSMutableArray *values;
} group_concat_ctxt;

void group_concat_step(sqlite3_context *ctx, int ncols, sqlite3_value **values)
{
    group_concat_ctxt *g;
    const unsigned char *bytes;
    
    g = (group_concat_ctxt *)sqlite3_aggregate_context(ctx, sizeof(group_concat_ctxt));
    
    if (sqlite3_aggregate_count(ctx) == 1)
    {
        g->values = [[NSMutableArray alloc] init];
    }
    
    bytes = sqlite3_value_text(values[0]); 
    [g->values addObject:[NSString stringWithCString:(const char *)bytes encoding:NSUTF8StringEncoding]];
}

void group_concat_finalize(sqlite3_context *ctx)
{
    group_concat_ctxt *g;
    
    g = (group_concat_ctxt *)sqlite3_aggregate_context(ctx, sizeof(group_concat_ctxt));
    const char *finalString = [[g->values componentsJoinedByString:@", "] UTF8String];
    sqlite3_result_text(ctx, finalString, strlen(finalString), NULL);
    [g->values release];
    g->values = nil;
}

// sqlite word search function

void word_search_func(sqlite3_context* ctx, int argc, sqlite3_value** argv)
{    
    int wasFound = 0;
    static NSCharacterSet *charSet = nil;
    
    if (!charSet)
    {
        charSet = [[NSCharacterSet characterSetWithCharactersInString:@" "] retain];
    }
    
    const unsigned char *s2 = sqlite3_value_text(argv[1]);
    NSString *string2 = [[NSString alloc] initWithUTF8String:(const char *)s2];
    
    // Borrow the buffer here
    const unsigned char *s1 = sqlite3_value_text(argv[0]);
    NSString *string1 = [[NSString alloc] initWithBytesNoCopy:(void *)s1 length:sqlite3_value_bytes(argv[0]) encoding:NSUTF8StringEncoding freeWhenDone:NO];
    
    // Prepare to be searched!
    int curLoc = 0;
    int maxLoc = [string1 length];
    
    int string2Len = [string2 length];
    while (curLoc < maxLoc)
    {
        NSRange searchRange = NSMakeRange(curLoc, maxLoc - curLoc);
        if (searchRange.length < string2Len)
        {
            break;
        }
        
        NSComparisonResult res = [string1 compare:string2 options:NSDiacriticInsensitiveSearch|NSCaseInsensitiveSearch range:NSMakeRange(curLoc, string2Len)];
        
        if (res == 0)
        {
            wasFound = 1;
            break;
        }
        
        // find the next whitespace to start from
        NSRange wsRange = [string1 rangeOfCharacterFromSet:charSet options:NSLiteralSearch range:searchRange];
        if (wsRange.location == NSNotFound)
        {
            break;
        }
        curLoc = wsRange.location + 1;
    }
    
    [string1 release];
    [string2 release];
        
    sqlite3_result_int(ctx, wasFound);
}

#import "CSqliteEnumerator.h"
#import "CSqliteDatabase_Extensions.h"

NSString *TouchSQLErrorDomain = @"TouchSQLErrorDomain";

@interface CSqliteDatabase ()
@property (readwrite, retain) NSString *path;
@property (readwrite, assign) sqlite3 *sql;
@end

@implementation CSqliteDatabase

@synthesize path;
@dynamic sql;

- (id)initWithPath:(NSString *)inPath
{
if (self = ([super init]))
	{
	self.path = inPath;
	}
return(self);
}

- (id)initInMemory;
{
return([self initWithPath:@":memory:"]);
}

- (void)dealloc
{
self.path = NULL;
[self close];
//
[super dealloc];
}

#pragma mark -

- (BOOL)open:(NSError **)outError
{
if (sql == NULL)
	{
	sqlite3 *theSql = NULL;
	int theResult = sqlite3_open([self.path UTF8String], &theSql);
	if (theResult != SQLITE_OK)
		{
		if (outError)
			*outError = [NSError errorWithDomain:TouchSQLErrorDomain code:theResult userInfo:NULL];
		return(NO);
		}
	self.sql = theSql;
    int res = sqlite3_create_function(theSql, "group_concat", 1, SQLITE_UTF8, theSql, NULL, group_concat_step, group_concat_finalize);    
    NSAssert(res == SQLITE_OK, @"Unable to register group_concat function!");
    res = sqlite3_create_function(theSql, "word_search", 2, SQLITE_UTF8, NULL, word_search_func, NULL, NULL);
    NSAssert(res == SQLITE_OK, @"Unable to register CADI collation!");    
	}
return(YES);
}

- (void)close
{
self.sql = NULL;
}

- (sqlite3 *)sql
{
return(sql);
}

- (void)setSql:(sqlite3 *)inSql
{
if (sql != inSql)
	{
	if (sql != NULL)
		{
		sqlite3_close(sql);
		sql = NULL;
		}
	sql = inSql;
	}
}

#pragma mark -

- (BOOL)executeExpression:(NSString *)inExpression error:(NSError **)outError
{
NSAssert(self.sql != NULL, @"Database not open.");

char *theMessage = NULL;
int theResult = sqlite3_exec(self.sql, [inExpression UTF8String], NULL, NULL, &theMessage);
if (theResult != SQLITE_OK) 
	{
	if (outError)
        {
        NSString *sqlErr = [NSString stringWithUTF8String:sqlite3_errmsg(self.sql)];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:sqlErr forKey:NSLocalizedDescriptionKey];
		*outError = [NSError errorWithDomain:TouchSQLErrorDomain code:theResult userInfo:userInfo];
        }
	if (theMessage)
		{
		sqlite3_free(theMessage); // TODO: If this is set then we've already thrown an exception and this will leak.
		}
	}
return(theResult == SQLITE_OK ? YES : NO);
}

- (NSEnumerator *)enumeratorForExpression:(NSString *)inExpression error:(NSError **)outError
{
NSAssert(self.sql != NULL, @"Database not open.");

const char *theTail = NULL;
sqlite3_stmt *theStatement = NULL;

int theResult = sqlite3_prepare(self.sql, [inExpression UTF8String], [inExpression length], &theStatement, &theTail);
if (theResult != SQLITE_OK) 
	{
	if (outError)
		*outError = [NSError errorWithDomain:TouchSQLErrorDomain code:theResult userInfo:NULL];
	return(NULL);
	}
NSAssert(strlen(theTail) == 0, @"enumeratorForExpression:, tail remaining for sqlite3_prepare");
	
CSqliteEnumerator *theEnumerator = [[[CSqliteEnumerator alloc] initWithStatement:theStatement] autorelease];

return(theEnumerator);
}

- (NSArray *)rowsForExpression:(NSString *)inExpression error:(NSError **)outError
{
NSAssert(self.sql != NULL, @"Database not open.");
int theColumnCount = 0;
int cColumnType = 0;
NSInteger cColumnIntegerVal;
NSMutableDictionary *cRowDict = nil;
double cColumnDoubleVal;
const unsigned char *cColumnCStrVal;
const void *cColumnBlobVal;
int cColumnBlobValLen;
id cBoxedColumnValue = nil;
const char* cColumnName;
sqlite3_stmt *pStmt = NULL;
const char *tail = NULL;

int theResult = sqlite3_prepare_v2(self.sql, [inExpression UTF8String], -1, 
                                   &pStmt, &tail);    

if (theResult != SQLITE_OK)
	{
	if (outError)
        {
        NSString *errStr = [NSString stringWithUTF8String:sqlite3_errmsg(self.sql)];
        *outError = [NSError errorWithDomain:TouchSQLErrorDomain 
                                        code:theResult 
                                    userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]];
        }
	return(NULL);
	}
//

NSMutableArray *theRowsArray = [NSMutableArray array];
theColumnCount = sqlite3_column_count(pStmt);
while ((theResult = sqlite3_step(pStmt)) == SQLITE_ROW)
    {        
    // Read the next row
    cRowDict = [NSMutableDictionary dictionaryWithCapacity:theColumnCount];
    
    for (int theColumn = 0; theColumn < theColumnCount; ++theColumn)
        {
            cColumnType = sqlite3_column_type(pStmt, theColumn);
            cColumnName = sqlite3_column_name(pStmt, theColumn);
            
            switch(cColumnType)
                {
                case SQLITE_INTEGER:
                    cColumnIntegerVal = sqlite3_column_int(pStmt, theColumn);
                    cBoxedColumnValue = [NSNumber numberWithInteger:cColumnIntegerVal];
                    break;
                case SQLITE_FLOAT:
                    cColumnDoubleVal = sqlite3_column_double(pStmt, theColumn);
                    cBoxedColumnValue = [NSNumber numberWithDouble:cColumnDoubleVal];
                    break;
                case SQLITE_BLOB:
                    cColumnBlobVal = sqlite3_column_blob(pStmt, theColumn);
                    cColumnBlobValLen = sqlite3_column_bytes(pStmt, theColumn);
                    cBoxedColumnValue = [NSData dataWithBytes:cColumnBlobVal length:cColumnBlobValLen];
                    break;
                case SQLITE_NULL:
                    cBoxedColumnValue = [NSNull null];
                    break;
                case SQLITE_TEXT:
                    cColumnCStrVal = sqlite3_column_text(pStmt, theColumn);
                    cBoxedColumnValue = [NSString stringWithUTF8String:(const char *)cColumnCStrVal];
                    break;
                }
            
            [cRowDict setObject:cBoxedColumnValue forKey:[NSString stringWithUTF8String:cColumnName]];
        }
    
    [theRowsArray addObject:cRowDict];
    }

if ( (theResult != SQLITE_OK) && (theResult != SQLITE_DONE) )
    {
    if (outError)
        {
        NSString *errStr = [NSString stringWithUTF8String:sqlite3_errmsg(self.sql)];
        *outError = [NSError errorWithDomain:TouchSQLErrorDomain 
                                        code:theResult 
                                    userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]];
        }
    }
    
sqlite3_finalize(pStmt);
pStmt = NULL;
    
return(theRowsArray);
}

- (BOOL)begin
{
    return [self executeExpression:@"BEGIN TRANSACTION" error:NULL];
}

- (BOOL)commit
{
    return [self executeExpression:@"COMMIT" error:NULL];
}

- (BOOL)rollback
{
    return [self executeExpression:@"ROLLBACK" error:NULL];
}

@end

#pragma mark -

@implementation CSqliteDatabase (CSqliteDatabase_Configuration)

@dynamic cacheSize;
@dynamic synchronous;
@dynamic tempStore;

- (NSString *)integrityCheck
{
return([self valueForExpression:@"pragma integrity_check;" error:NULL]);
}

- (int)cacheSize
{
return([[self valueForExpression:@"pragma cache_size;" error:NULL] intValue]);
}

- (void)setCacheSize:(int)inCacheSize
{
[self executeExpression:[NSString stringWithFormat:@"pragma cache_size=%d;", inCacheSize] error:NULL];
}

- (int)synchronous
{
return([[self valueForExpression:@"pragma synchronous;" error:NULL] intValue]);
}

- (void)setSynchronous:(int)inSynchronous
{
[self executeExpression:[NSString stringWithFormat:@"pragma synchronous=%d;", inSynchronous] error:NULL];
}

- (int)tempStore
{
return([[self valueForExpression:@"pragma temp_store;" error:NULL] intValue]);
}

- (void)setTempStore:(int)inTempStore
{
[self executeExpression:[NSString stringWithFormat:@"pragma temp_store=%d;", inTempStore] error:NULL];
}

@end
