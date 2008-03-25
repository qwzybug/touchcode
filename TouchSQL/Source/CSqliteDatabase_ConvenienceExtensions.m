//
//  CSqliteDatabase_ConvenienceExtensions.m
//  Prototype
//
//  Created by Jonathan Wight on Mon May 17 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "CSqliteDatabase_ConvenienceExtensions.h"

#import "CSqliteDatabase_Extensions.h"
#import "NSArray_SqlExtensions.h"

@implementation CSqliteDatabase (CSqliteDatabase_ConvenienceExtensions)

- (BOOL)populateTableName:(NSString *)inTableName tableColumns:(NSArray *)inTableColumns columnTypes:(NSArray *)inColumnTypes indexName:(NSString *)inIndexName indexColumns:(NSArray *)inIndexColumns primaryKey:(NSString *)inPrimaryKey withDictionariesFromEnumerator:(NSEnumerator *)inEnumerator error:(NSError **)outError
{
// ### Create table and index...
if ([self tableExists:inTableName] == NO)
	{
	NSMutableArray *theTableColumns = [NSMutableArray array];
	//
	NSDictionary *theTypesByColumn = [NSDictionary dictionaryWithObjects:inColumnTypes forKeys:inTableColumns];
	NSEnumerator *theEnumerator = [inTableColumns objectEnumerator];
	NSString *theColumn = NULL;
	while ((theColumn = [theEnumerator nextObject]) != NULL)
		{
		if ([theColumn isEqual:inPrimaryKey])
			[theTableColumns addObject:[NSString stringWithFormat:@"%@ integer primary key unique", theColumn]];
		else
			[theTableColumns addObject:[NSString stringWithFormat:@"%@ %@", theColumn, [theTypesByColumn objectForKey:theColumn]]];
		}

	NSString *theSQL = [NSString stringWithFormat:@"create table %@ (%@)", inTableName, [theTableColumns componentsJoinedByString:@", "]];
	[self executeExpression:theSQL error:outError];
	}
if (inIndexName != NULL)
	{
	if ([self objectExistsOfType:@"index" name:inIndexName temporary:NO] == NO)
		{
		NSString *theSQL = [NSString stringWithFormat:@"create unique index %@ on %@(%@)", inIndexName, inTableName, [inIndexColumns componentsJoinedByString:@", "]];
		[self executeExpression:theSQL error:outError];
		}
	}
// ### Enumerator through the dictionaries and insert them into the table...
NSDictionary *theDictionary = NULL;
while ((theDictionary = [inEnumerator nextObject]) != NULL)
	{
	NSAutoreleasePool *theAutoreleasePool = [[NSAutoreleasePool alloc] init];
	//
	NSString *theSQL = [NSString stringWithFormat:@"replace into %@(%@) values (%@)", inTableName, [[theDictionary allKeys] componentsJoinedByString:@", "], [[theDictionary allValues] componentsJoinedByQuotedSQLEscapedCommas]];
	[self executeExpression:theSQL error:outError];
	//
	[theAutoreleasePool release];
	}
}


@end
