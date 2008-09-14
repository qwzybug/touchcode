//
//  CRSSChannel.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright (c) 2008 Jonathan Wight
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CFeed.h"

#import "CFeedStore.h"
#import "CSqliteDatabase.h"
#import "CFeedEntry.h"
#import "NSString_SqlExtensions.h"
#import "CSqliteDatabase_Extensions.h"
#import "NSDate_SqlExtension.h"
#import "NSString_SqlExtensions.h"
#import "CPersistentObjectManager.h"
#import "CRandomAccessTemporaryTable.h"

@interface CFeed ()
@property (readwrite, nonatomic, retain) CRandomAccessTemporaryTable *randomAccessTemporaryTable;
@end

#pragma mark -

@implementation CFeed

@synthesize feedStore, updating, lastChecked, url;
@synthesize identifier, title, link, subtitle;
@dynamic randomAccessTemporaryTable;

+ (NSString *)tableName
{
return(@"feed");
}

- (void)dealloc
{
self.feedStore = NULL;
self.randomAccessTemporaryTable = NULL;
self.url = NULL;
self.title = NULL;
self.link = NULL;
self.subtitle = NULL;
self.lastChecked = NULL;
//
[super dealloc];
}

#pragma mark -

- (CRandomAccessTemporaryTable *)randomAccessTemporaryTable
{
if (randomAccessTemporaryTable == NULL)
	{
	CRandomAccessTemporaryTable *theRandomAccessTemporaryTable = [[[CRandomAccessTemporaryTable alloc] initWithDatabase:self.persistentObjectManager.database dropOnDealloc:YES] autorelease];
	
	NSString *theStatement = [NSString stringWithFormat:@"SELECT id FROM entry WHERE feed_id = %d ORDER BY updated DESC", self.rowID];
	NSError *theError = NULL;
	if ([theRandomAccessTemporaryTable insertForeignIds:theStatement error:&theError] == NO)
		{
		[NSException raise:NSGenericException format:@"%@", theError];
		}

	randomAccessTemporaryTable = [theRandomAccessTemporaryTable retain];
	}
return(randomAccessTemporaryTable); 
}

- (void)setRandomAccessTemporaryTable:(CRandomAccessTemporaryTable *)inRandomAccessTemporaryTable
{
if (randomAccessTemporaryTable != inRandomAccessTemporaryTable)
	{
	[randomAccessTemporaryTable release];
	randomAccessTemporaryTable = [inRandomAccessTemporaryTable retain];
    }
}

#pragma mark -

- (void)addEntry:(CFeedEntry *)inEntry
{
// TODO
self.randomAccessTemporaryTable = NULL;
}

- (NSInteger)countOfEntries
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT count() FROM entry WHERE feed_id = %d", self.rowID];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
return([[theDictionary objectForKey:@"count()"] intValue]);
}

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT foreign_id FROM %@ WHERE id = %d LIMIT 1", self.randomAccessTemporaryTable.tableName, inIndex + 1];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	return(NULL);

NSInteger theRowID = [[theDictionary objectForKey:@"foreign_id"] integerValue];

CFeedEntry *theFeedEntry = [self.persistentObjectManager loadPersistentObjectOfClass:[CFeedEntry class] rowID:theRowID error:&theError];
[theFeedEntry retain];

[thePool release];

[theFeedEntry autorelease];

return(theFeedEntry);
}

- (CFeedEntry *)entryForIdentifier:(NSString *)inIdentifier
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT id FROM entry WHERE feed_id = %d AND identifier = '%@' LIMIT 1", self.rowID, [inIdentifier encodedForSql]];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	return(NULL);
NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];

CFeedEntry *theFeedEntry = [self.persistentObjectManager loadPersistentObjectOfClass:[CFeedEntry class] rowID:theRowID error:&theError];

return(theFeedEntry);
}

- (BOOL)write:(NSError **)outError
{
CSqliteDatabase *theDatabase = self.persistentObjectManager.database;

if (self.rowID == -1)
	{
	NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO feed (url, title, link, subtitle, lastChecked) VALUES ('%@', '%@', '%@', '%@', '%@')", [[self.url absoluteString] encodedForSql], [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.subtitle encodedForSql], [self.lastChecked sqlDateString]];

	BOOL theResult = [theDatabase executeExpression:theExpression error:outError];
	if (theResult == NO)
		{
		return(NO);
		}

	theExpression = [NSString stringWithFormat:@"SELECT id FROM feed WHERE (url = %@)", [[self.url absoluteString] encodedForSql]];
	NSDictionary *theRow = [theDatabase rowForExpression:theExpression error:outError];
	if (theResult == NO)
		{
		return(NO);
		}

	self.rowID = [[theRow objectForKey:@"id"] integerValue];
	}
else
	{
	NSLog(@"TODO: PASS");
	}

return(YES);
}

@end
