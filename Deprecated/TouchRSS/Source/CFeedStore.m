//
//  CFeedStore.m
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

#import "CFeedStore.h"

#import "CSqliteDatabase.h"
#import "CObjectTranscoder.h"
#import "CFeed.h"
#import "CFeedEntry.h"
#import "NSDate_SqlExtension.h"
#import "NSString_SqlExtensions.h"
#import "CSqliteDatabase_Extensions.h"
#import "CPersistentObjectManager.h"
#import "CFeedFetcher.h"

#if !defined(TOUCHRSS_ALWAYS_RESET_DATABASE)
#define TOUCHRSS_ALWAYS_RESET_DATABASE 0
#endif /* !defined(TOUCHRSS_ALWAYS_RESET_DATABASE) */

@interface CFeedStore ()
@property (readwrite, nonatomic, retain) CPersistentObjectManager *persistentObjectManager;
@property (readwrite, nonatomic, retain) CFeedFetcher *feedFetcher;
@property (readwrite, nonatomic, retain) NSArray *feeds;
@end

#pragma mark -

@implementation CFeedStore

@dynamic databasePath;
@dynamic persistentObjectManager;
@synthesize feedFetcher;
@dynamic feeds;

+ (Class)feedClass
{
return([CFeed class]);
}

+ (Class)feedEntryClass
{
return([CFeedEntry class]);
}

+ (Class)feedFetcherClass {
return([CFeedFetcher class]);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.feedFetcher = [[[[[self class] feedFetcherClass] alloc] initWithFeedStore:self] autorelease];
	}
return(self);
}

- (void)dealloc
{
self.databasePath = NULL;
self.feedFetcher = NULL;
self.feeds = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)databasePath
{
if (databasePath == NULL)
	{
	NSString *theApplicationSupportFolder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *thePath = [theApplicationSupportFolder stringByAppendingPathComponent:@"feedstore.db"];
	databasePath = [thePath retain];
	}
return(databasePath);
}

- (void)setDatabasePath:(NSString *)inDatabasePath
{
if (databasePath != inDatabasePath)
	{
	[databasePath autorelease];
	databasePath = [inDatabasePath retain];
    }
}

- (CPersistentObjectManager *)persistentObjectManager
{
if (persistentObjectManager == NULL)
	{
	NSError *theError = NULL;

	#if TOUCHRSS_ALWAYS_RESET_DATABASE == 1
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath] == YES)
		{
		NSLog(@"REMOVING FEEDSTORE");
		if ([[NSFileManager defaultManager] removeItemAtPath:self.databasePath error:&theError] == NO)
			[NSException raise:NSGenericException format:@"Remove feed store failed: %@", theError];
		}
	#endif /* TOUCHRSS_ALWAYS_RESET_DATABASE == 1 */

	if ([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath] == NO)
		{
		if ([[NSFileManager defaultManager] createDirectoryAtPath:[self.databasePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:NULL error:&theError] == NO)
			[NSException raise:NSGenericException format:@"Creating directory failed: @", theError];

		NSString *theSourcePath = [[NSBundle mainBundle] pathForResource:@"FeedStore" ofType:@"db"];
		if ([[NSFileManager defaultManager] copyItemAtPath:theSourcePath toPath:self.databasePath error:&theError] == NO)
			[NSException raise:NSGenericException format:@"Copying template database failed: %@", theError];
		}

	CSqliteDatabase *theDatabase = [[[CSqliteDatabase alloc] initWithPath:self.databasePath] autorelease];
	[theDatabase open:&theError];
	if (theError)
		[NSException raise:NSGenericException format:@"Create database failed: %@", theError];

	CPersistentObjectManager *theManager = [[[CPersistentObjectManager alloc] initWithDatabase:theDatabase] autorelease];
	persistentObjectManager = [theManager retain];
	}
return(persistentObjectManager);
}

- (void)setPersistentObjectManager:(CPersistentObjectManager *)inPersistentObjectManager
{
if (persistentObjectManager != inPersistentObjectManager)
	{
	[persistentObjectManager autorelease];
	persistentObjectManager = [inPersistentObjectManager retain];
    }
}

#pragma mark -

- (NSArray *)feeds
{
if (mutableFeeds == NULL)
	{
	NSMutableArray *theFeeds = [NSMutableArray array];

	NSError *theError = NULL;
	NSString *theExpression = [NSString stringWithFormat:@"SELECT id FROM feed"];
	NSArray *theRows = [self.persistentObjectManager.database rowsForExpression:theExpression error:&theError];

	for (NSDictionary *theRow in theRows)
		{
		NSInteger theRowID = [[theRow objectForKey:@"id"] integerValue];

		CFeed *theFeed = [self.persistentObjectManager loadPersistentObjectOfClass:[[self class] feedClass] rowID:theRowID error:&theError];
		[theFeeds addObject:theFeed];
		}

	self.feeds = theFeeds;
	}

return(mutableFeeds);
}

- (void)setFeeds:(NSArray *)inFeeds
{
if (mutableFeeds != inFeeds)
	{
	[mutableFeeds autorelease];
	mutableFeeds = [inFeeds mutableCopy];
    }
}

- (NSInteger)countOfFeeds
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT count() FROM feed"];
NSDictionary *theRow = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theRow == NULL)
	[NSException raise:NSGenericException format:@"Count of Feeds failed: %@", theError];
return([[theRow objectForKey:@"count()"] integerValue]);
}

- (CFeed *)feedAtIndex:(NSInteger)inIndex
{
// TODO: DO NOT DO THIS: http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT id FROM feed LIMIT 1 OFFSET %d", inIndex];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	[NSException raise:NSGenericException format:@"Feed at Index failed: %@", theError];

NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];

CFeed *theFeed = [self.persistentObjectManager loadPersistentObjectOfClass:[[self class] feedClass] rowID:theRowID error:&theError];

return(theFeed);
}

- (CFeed *)feedforURL:(NSURL *)inURL
{
CFeed *theFeed = NULL;
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT id FROM feed WHERE url = '%@'", [[inURL absoluteString] encodedForSql]];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary != NULL)
	{
	NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];
	theFeed = [self.persistentObjectManager loadPersistentObjectOfClass:[[self class] feedClass] rowID:theRowID error:&theError];
	theFeed.feedStore = self;
	}
else
	{
	theFeed = [self.persistentObjectManager makePersistentObjectOfClass:[[self class] feedClass] error:&theError];
	theFeed.feedStore = self;
	theFeed.link = inURL;
	theFeed.url = inURL;
	if ([theFeed write:&theError] == NO)
		theFeed = NULL;
	}

return(theFeed);
}

- (NSArray *)entriesForFeeds:(NSArray *)inFeeds;
{
return([self entriesForFeeds:inFeeds sortByColumn:@"updated" descending:YES limit:-1]);
}

- (NSArray *)entriesForFeeds:(NSArray *)inFeeds sortByColumn:(NSString *)inColumn descending:(BOOL)inDescending limit:(NSInteger)inLimit
{
NSMutableArray *theEntries = [NSMutableArray array];

Class theClass = [[self class] feedEntryClass];

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM entry WHERE feed_id IN (%@)", [[inFeeds valueForKey:@"rowID"]componentsJoinedByString:@","]];

theExpression = [theExpression stringByAppendingFormat:@" ORDER BY %@ %@", inColumn, inDescending ? @"DESC" : @""];
if (inLimit > 0)
	theExpression = [theExpression stringByAppendingFormat:@" LIMIT %d", inLimit];

for (NSDictionary *theDictionary in [self.persistentObjectManager.database rowsForExpression:theExpression error:&theError])
	{
	NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];
	CFeedEntry *theEntry = [self.persistentObjectManager loadPersistentObjectOfClass:theClass rowID:theRowID fromDictionary:theDictionary error:&theError];
	if (theEntry == NULL)
		{
		[NSException raise:NSGenericException format:@"Could not create entry: %@", theError];
		}
	[theEntries addObject:theEntry];
	}

return([[theEntries copy] autorelease]);
}

@end
