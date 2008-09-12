//
//  CSqliteStatement.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CSqliteStatement.h"

#import "CSqliteDatabase.h"

@interface CSqliteStatement ()
@property (readwrite, nonatomic, assign) CSqliteDatabase *database;
@property (readwrite, nonatomic, copy) NSString *string;
@property (readwrite, nonatomic, assign) sqlite3_stmt *statement;
@end

@implementation CSqliteStatement

@synthesize database;
@synthesize string;
@synthesize statement;

+ (CSqliteStatement *)statementWithDatabase:(CSqliteDatabase *)inDatabase format:(NSString *)inFormat, ...;
{
return(NULL);
}

- (id)initWithDatabase:(CSqliteDatabase *)inDatabase string:(NSString *)inString;
{
if ((self = [self init]) != NULL)
	{
	self.database = inDatabase;
	self.string = inString;
	}
return(self);
}

- (void)dealloc
{
self.database = NULL;
self.string = NULL;
if (statement != NULL)
	{
	sqlite3_finalize(statement);
	statement = NULL;
	}
//
[super dealloc];
}

#pragma mark -

- (BOOL)compile:(NSError **)outError;
{
if (statement != NULL)
	{
	if (outError)
        {
        NSString *theErrorString = @"Cannot compile a statement that has already been compiled.";
        *outError = [NSError errorWithDomain:NSGenericException code:-1 userInfo:[NSDictionary dictionaryWithObject:theErrorString forKey:NSLocalizedDescriptionKey]];
        }

	return(NO);
	}

sqlite3_stmt *theStatement = NULL;
const char *theTail = NULL;

int theResult = sqlite3_prepare_v2(self.database.sql, [self.string UTF8String], [self.string length], &theStatement, &theTail);
if (theResult != SQLITE_OK)
	{	
	if (outError)
        {
        NSString *theErrorString = [NSString stringWithUTF8String:sqlite3_errmsg(self.database.sql)];
        *outError = [NSError errorWithDomain:TouchSQLErrorDomain code:theResult userInfo:[NSDictionary dictionaryWithObject:theErrorString forKey:NSLocalizedDescriptionKey]];
        }

	if (theStatement != NULL)
		sqlite3_finalize(theStatement);

	return(NO);
	}

if (statement != NULL)
	{
	sqlite3_finalize(statement);
	statement = NULL;
	}

statement = theStatement;

return(YES);
}

@end
