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

- (void)open
{
if (sql == NULL)
	{
	sqlite3 *theSql = NULL;
	int theResult = sqlite3_open([self.path UTF8String], &theSql);
	if (theResult != SQLITE_OK) [NSException raise:NSGenericException format:@"sqlite3_open() failed with %d", theResult];
	self.sql = theSql;
	}
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

- (void)executeExpression:(NSString *)inExpression
{
NSAssert(self.sql != NULL, @"Database not open.");

char *theMessage = NULL;
int theResult = sqlite3_exec(self.sql, [inExpression UTF8String], NULL, NULL, &theMessage);
if (theResult != SQLITE_OK) [NSException raise:NSGenericException format:@"sqlite3_exec() failed with %s", theMessage];
if (theMessage)
	{
	sqlite3_free(theMessage); // TODO: If this is set then we've already thrown an exception and this will leak.
	}
}

- (NSEnumerator *)enumeratorForExpression:(NSString *)inExpression
{
NSAssert(self.sql != NULL, @"Database not open.");

char *theMessage = NULL;
const char *theTail;
sqlite3_stmt *theStatement;

int theResult = sqlite3_prepare(self.sql, [inExpression UTF8String], [inExpression length], &theStatement, &theTail);
if (theResult != SQLITE_OK) [NSException raise:NSGenericException format:@"sqlite3_compile() failed with %d", theResult];
if (theMessage)
	{
	sqlite3_free(theMessage); // TODO: If this is set then we've already thrown an exception and this will leak.
	}
if (strlen(theTail) != 0) [NSException raise:NSGenericException format:@"sqlite3_compile() tail is not empty (\"%s\")", theTail];
//
CSqliteEnumerator *theEnumerator = [[[CSqliteEnumerator alloc] initWithStatement:theStatement] autorelease];

return(theEnumerator);
}

- (NSArray *)rowsForExpression:(NSString *)inExpression
{
NSAssert(self.sql != NULL, @"Database not open.");
char **theRows = NULL;
int theRowCount = 0;
int theColumnCount = 0;
char *theMessage;
int theResult = sqlite3_get_table(self.sql, [inExpression UTF8String], &theRows, &theRowCount, &theColumnCount, &theMessage);
if (theResult != SQLITE_OK) [NSException raise:NSGenericException format:@"sqlite3_get_table() failed with \"%s\"", theMessage];
if (theMessage)
	{
	sqlite3_free(theMessage); // TODO: If this is set then we've already thrown an exception and this will leak.
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

- (NSString *)integrityCheck
{
return([self valueForExpression:@"pragma integrity_check;"]);
}

- (void)setCacheSize:(int)inCacheSize
{
[self executeExpressionFormat:@"pragma cache_size=%d;", inCacheSize];
}

- (int)cacheSize
{
return([[self valueForExpression:@"pragma cache_size;"] intValue]);
}

- (void)setSynchronous:(int)inSynchronous
{
[self executeExpressionFormat:@"pragma synchronous=%d;", inSynchronous];
}

- (int)synchronous
{
return([[self valueForExpression:@"pragma synchronous;"] intValue]);
}

- (void)setTempStore:(int)inTempStore
{
[self executeExpressionFormat:@"pragma temp_store=%d;", inTempStore];
}

- (int)tempStore
{
return([[self valueForExpression:@"pragma temp_store;"] intValue]);
}

@end
