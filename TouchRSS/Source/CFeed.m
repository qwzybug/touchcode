//
//  CFeed.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "CSqliteDatabase.h"
#import "CFeedEntry.h"
#import "NSString_SqlExtensions.h"
#import "CSqliteDatabase_Extensions.h"
#import "NSDate_SqlExtension.h"
#import "NSString_SqlExtensions.h"
#import "CPersistentObjectManager.h"
#import "CRandomAccessTemporaryTable.h"
#import "CFeedStore.h"
#import "CObjectTranscoder.h"

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

+ (NSArray *)persistentPropertyNames
{
return([[super persistentPropertyNames] arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:@"identifier", @"title", @"link", @"subtitle", @"url", @"lastChecked", NULL]]);
}

+ (CObjectTranscoder *)objectTranscoder
{
CObjectTranscoder *theTranscoder = [[[CObjectTranscoder alloc] initWithTargetObjectClass:[self class]] autorelease];
theTranscoder.propertyNameMappings = [NSDictionary dictionaryWithObjectsAndKeys:
	@"rowID", @"id",
	NULL];
return(theTranscoder);
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
self.identifier = NULL;
//
[super dealloc];
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (row_id: %d, identifier: %@, title: %@)", [super description], self.rowID, self.identifier, self.title]);
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
		[NSException raise:NSGenericException format:@"RAT TABLE INSERT FAILED: %@", theError];
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
CFeedEntry *theFeedEntry = NULL;

NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT foreign_id FROM %@ WHERE id = %d LIMIT 1", self.randomAccessTemporaryTable.tableName, inIndex + 1];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary)
	{
	NSInteger theRowID = [[theDictionary objectForKey:@"foreign_id"] integerValue];

	theFeedEntry = [self.persistentObjectManager loadPersistentObjectOfClass:[[self.feedStore class] feedEntryClass] rowID:theRowID error:&theError];
	[theFeedEntry retain];

	[thePool release];

	[theFeedEntry autorelease];
	}
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

CFeedEntry *theFeedEntry = [self.persistentObjectManager loadPersistentObjectOfClass:[[self.feedStore class] feedEntryClass] rowID:theRowID error:&theError];
if (theFeedEntry == NULL)
	{
	[NSException raise:NSGenericException format:@"loadPersistentObjectOfClass failed: %@", theError];
	}

return(theFeedEntry);
}

@end
