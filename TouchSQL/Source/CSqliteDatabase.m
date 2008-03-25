//
//  CSqliteDatabase.m
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase.h"

#include <sqlite3.h>

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
		*outError = [NSError errorWithDomain:TouchSQLErrorDomain code:theResult userInfo:NULL];
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
char **theRows = NULL;
int theRowCount = 0;
int theColumnCount = 0;
char *theMessage;
int theResult = sqlite3_get_table(self.sql, [inExpression UTF8String], &theRows, &theRowCount, &theColumnCount, &theMessage);
if (theResult != SQLITE_OK)
	{
	if (outError)
		*outError = [NSError errorWithDomain:TouchSQLErrorDomain code:theResult userInfo:NULL];
	if (theMessage)
		{
		sqlite3_free(theMessage); // TODO: If this is set then we've already thrown an exception and this will leak.
		}
	return(NULL);
	}
//
NSMutableArray *theKeys = [NSMutableArray array];
for (int theColumn = 0; theColumn < theColumnCount; ++theColumn)
	{
	NSString *theKey = [NSString stringWithUTF8String:theRows[theColumn]];
	[theKeys addObject:theKey];
	}
//
NSMutableArray *theRowsArray = [NSMutableArray array];
for (int theRow = 1; theRow < theRowCount + 1; ++theRow)
	{
	NSMutableArray *theValues = [NSMutableArray array];
	for (int theColumn = 0; theColumn != theColumnCount; ++theColumn)
		{
		int theIndex = theRow * theColumnCount + theColumn;
		char *theString = theRows[theIndex];;
		id theValue = NULL;
		if (theString == NULL)
			theValue = [NSNull null];
		else
			theValue = [NSString stringWithUTF8String:theString];
		[theValues addObject:theValue];
		}
	//
	NSMutableDictionary *theRowDictionary = [NSMutableDictionary dictionaryWithObjects:theValues forKeys:theKeys];
	[theRowsArray addObject:theRowDictionary];
	}
//
return(theRowsArray);
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
