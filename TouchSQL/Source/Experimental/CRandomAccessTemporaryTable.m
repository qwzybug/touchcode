//
//  CRandomAccessTemporaryTable.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CRandomAccessTemporaryTable.h"
#import "CSqliteDatabase.h"

@interface CRandomAccessTemporaryTable ()
@property (readwrite, nonatomic, retain) CSqliteDatabase *database;
@property (readwrite, nonatomic, retain) NSString *tableName;
@property (readwrite, nonatomic, assign) BOOL dropOnDealloc;
@end

@implementation CRandomAccessTemporaryTable

@synthesize database;
@synthesize tableName;
@synthesize dropOnDealloc;

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase dropOnDealloc:(BOOL)inDropObDealloc;
{
if ((self = [super init]) != NULL)
	{
	self.database = inDatabase;
	self.dropOnDealloc = inDropObDealloc;

	NSError *theError = NULL;
	if ([self createTable:&theError] == NO)
		[NSException raise:NSGenericException format:@"CRandomAccessTemporaryTable initWithDatabase failed %@", theError];
	}
return(self);
}

- (void)dealloc
{
if (self.dropOnDealloc)
	{
	[self dropTable:NULL];
	}

self.tableName = NULL;
self.database = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)tableName
{
if (tableName == NULL)
	{
	tableName = [[NSString alloc] initWithFormat:@"TEMP_RAT_TABLE_%d", ((unsigned)rand()) % 10000000];
	}
return(tableName); 
}

- (void)setTableName:(NSString *)inTableName
{
if (tableName != inTableName)
	{
	[tableName autorelease];
	tableName = [inTableName retain];
    }
}

#pragma mark -

- (BOOL)createTable:(NSError **)outError
{
[self.database begin];

NSString *theExpression = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", self.tableName];
BOOL theResult = [self.database executeExpression:theExpression error:outError];
if (theResult == NO)
	{
	[self.database rollback];
	return(NO);
	}

theExpression = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, foreign_id);", self.tableName];
theResult = [self.database executeExpression:theExpression error:outError];
if (theResult == NO)
	{
	[self.database rollback];
	return(NO);
	}

[self.database commit];

return(YES);
}

- (BOOL)dropTable:(NSError **)outError
{
NSString *theExpression = [NSString stringWithFormat:@"DROP TABLE %@", self.tableName];
BOOL theResult = [self.database executeExpression:theExpression error:outError];
return(theResult);
}

- (BOOL)insertForeignIds:(NSString *)inSelectStatement error:(NSError **)outError
{
[self.database begin];

NSString *theExpression = [NSString stringWithFormat:@"DELETE FROM %@", self.tableName];
BOOL theResult = [self.database executeExpression:theExpression error:outError];
if (theResult == NO)
	{
	[self.database rollback];
	return(NO);
	}

theExpression = [NSString stringWithFormat:@"INSERT INTO %@ (foreign_id) %@", self.tableName, inSelectStatement];
theResult = [self.database executeExpression:theExpression error:outError];
if (theResult == NO)
	{
	[self.database rollback];
	return(NO);
	}

[self.database commit];

return(YES);
}

@end
