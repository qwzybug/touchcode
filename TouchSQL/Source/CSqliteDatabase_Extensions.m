//
//  CSqliteDatabase_Extensions.m
//  DBTest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase_Extensions.h"


@implementation CSqliteDatabase (CSqliteDatabase_Extensions)

- (BOOL)executeExpressionIgnoringExceptions:(NSString *)inExpression
{
char *theMessage = NULL;

int theResult = sqlite3_exec(self.sql, [inExpression UTF8String], NULL, NULL, &theMessage);
if (theMessage)
	{
	sqlite3_free(theMessage);
	}
return(theResult == SQLITE_OK);
}

- (void)executeExpressionFormat:(NSString *)inFormat, ...
{
va_list theArgs;
va_start(theArgs, inFormat);
NSString *theExpression = [[[NSString alloc] initWithFormat:inFormat arguments:theArgs] autorelease];
va_end(theArgs);
[self executeExpression:theExpression];
}

- (NSEnumerator *)enumeratorForExpressionFormat:(NSString *)inFormat, ...
{
va_list theArgs;
va_start(theArgs, inFormat);
NSString *theExpression = [[[NSString alloc] initWithFormat:inFormat arguments:theArgs] autorelease];
va_end(theArgs);
return([self enumeratorForExpression:theExpression]);
}

// TODO -- most of these methods can be heavily optimised and more error checking added (search for NULL)

- (NSUInteger)countRowsInTable:(NSString *)inTableName
{
id theEnumerator = [self enumeratorForExpressionFormat:@"select count(*) from %@;", inTableName];
NSArray *theObjects = [theEnumerator allObjects];
// TODO make sure only 1 object is returned.
NSArray *theValues = [[theObjects lastObject] allValues];
// TODO make sure only 1 object is returned.
NSString *theString = [theValues lastObject];
return([theString intValue]);
}

- (NSDictionary *)rowForExpression:(NSString *)inExpression
{
NSArray *theRows = [self rowsForExpression:inExpression];
if ([theRows count] > 0)
	return([theRows objectAtIndex:0]);
else
	return(NULL);
}

- (NSArray *)valuesForExpression:(NSString *)inExpression
{
NSDictionary *theRow = [self rowForExpression:inExpression];
return([theRow allValues]);
}

- (NSString *)valueForExpression:(NSString *)inExpression
{
NSArray *theValues = [self valuesForExpression:inExpression];
// TODO -- check only 1 object is returned?
return([theValues lastObject]);
}

- (BOOL)objectExistsOfType:(NSString *)inType name:(NSString *)inTableName temporary:(BOOL)inTemporary
{
NSString *theSQL = [NSString stringWithFormat:@"select count(*) from %@ where TYPE = '%@' and NAME = '%@'", inTemporary == YES ? @"SQLITE_TEMP_MASTER" : @"SQLITE_MASTER", inType, inTableName];
NSString *theValue = [self valueForExpression:theSQL];
return([theValue intValue] == 1);
}

- (BOOL)tableExists:(NSString *)inTableName
{
return([self objectExistsOfType:@"table" name:inTableName temporary:NO]);
}

- (BOOL)temporaryTableExists:(NSString *)inTableName
{
return([self objectExistsOfType:@"table" name:inTableName temporary:YES]);
}

@end
