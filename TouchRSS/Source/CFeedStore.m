//
//  CFeedStore.m
//  ProjectV
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

#import "CFeedStore.h"

#import "CSqliteDatabase.h"
#import "CURLConnectionManager.h"
#import "CRSSFeedDeserializer.h"
#import "CObjectTranscoder.h"
#import "CFeed.h"
#import "CFeedEntry.h"
#import "NSDate_SqlExtension.h"
#import "NSString_SqlExtensions.h"
#import "CSqliteDatabase_Extensions.h"
#import "CPersistentObjectManager.h"

#if !defined(TOUCHRSS_ALWAYS_RESET_DATABASE)
#define TOUCHRSS_ALWAYS_RESET_DATABASE 0
#endif /* !defined(TOUCHRSS_ALWAYS_RESET_DATABASE) */

static CFeedStore *gInstance = NULL;

@interface CFeedStore ()
@property (readwrite, nonatomic, retain) CPersistentObjectManager *persistentObjectManager;
@property (readwrite, nonatomic, retain) NSMutableSet *currentURLs;
@end

#pragma mark -

@implementation CFeedStore

@dynamic databasePath;
@dynamic persistentObjectManager;
@synthesize currentURLs;

+ (CFeedStore *)instance
{
@synchronized(self)
	{
	if (gInstance == NULL)
		{
		gInstance = [[self alloc] init];
		}
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.currentURLs = [NSMutableSet set];
	}
return(self);
}

- (void)dealloc
{
self.databasePath = NULL;
self.currentURLs = NULL;
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
			[NSException raise:NSGenericException format:@"%@", theError];
		}
	#endif /* TOUCHRSS_ALWAYS_RESET_DATABASE == 1 */
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath] == NO)
		{
		if ([[NSFileManager defaultManager] createDirectoryAtPath:[self.databasePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:NULL error:&theError] == NO)
			[NSException raise:NSGenericException format:@"%@", theError];

		NSString *theSourcePath = [[NSBundle mainBundle] pathForResource:@"FeedStore" ofType:@"db"];
		if ([[NSFileManager defaultManager] copyItemAtPath:theSourcePath toPath:self.databasePath error:&theError] == NO)
			[NSException raise:NSGenericException format:@"%@", theError];
		}
	
	CSqliteDatabase *theDatabase = [[[CSqliteDatabase alloc] initWithPath:self.databasePath] autorelease];
	[theDatabase open:&theError];
	if (theError)
		[NSException raise:NSGenericException format:@"%@", theError];

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

- (NSInteger)countOfFeeds
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT count() FROM feed"];
NSDictionary *theRow = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theRow == NULL)
	[NSException raise:NSGenericException format:@"%@", theError];
return([[theRow objectForKey:@"count()"] integerValue]);
}

- (CFeed *)feedAtIndex:(NSInteger)inIndex
{
// TODO: DO NOT DO THIS: http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT id FROM feed LIMIT 1 OFFSET %d", inIndex];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	[NSException raise:NSGenericException format:@"%@", theError];
	
NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];

CFeed *theFeed = [self.persistentObjectManager loadPersistentObjectOfClass:[CFeed class] rowID:theRowID error:&theError];

return(theFeed);
}

- (CFeed *)feedforURL:(NSURL *)inURL
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT id FROM feed WHERE url = '%@'", [[inURL absoluteString] encodedForSql]];
NSDictionary *theDictionary = [self.persistentObjectManager.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	return(NULL);

NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];

CFeed *theFeed = [self.persistentObjectManager loadPersistentObjectOfClass:[CFeed class] rowID:theRowID error:&theError];

return(theFeed);
}

- (NSArray *)entriesForFeeds:(NSArray *)inFeeds;
{
NSMutableArray *theEntries = [NSMutableArray array];

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM entry WHERE feed_id IN (%@) ORDER BY updated DESC", [[inFeeds valueForKey:@"rowID"] componentsJoinedByString:@","]];
//NSLog(@"%@", theExpression);
NSEnumerator *theEnumerator = [self.persistentObjectManager.database enumeratorForExpression:theExpression error:&theError];
for (NSDictionary *theDictionary in theEnumerator)
	{
	// TODO we have the whole entry at this point and we're just using the row id. ARE WE INSANE???
	NSInteger theRowID = [[theDictionary objectForKey:@"id"] integerValue];
	CFeedEntry *theEntry = [self.persistentObjectManager loadPersistentObjectOfClass:[CFeedEntry class] rowID:theRowID error:&theError];
//	NSLog(@"%d, %@, %d %@", theRowID, [theDictionary objectForKey:@"updated"], theEntry.rowID, [theEntry.updated sqlDateString]);
	[theEntries addObject:theEntry];
	}

return([[theEntries copy] autorelease]);
}

- (CFeed *)subscribeToURL:(NSURL *)inURL error:(NSError **)outError
{
CFeed *theFeed = [self feedforURL:inURL];
if (theFeed)
	return(NULL);

NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO feed (url) VALUES('%@')", [inURL absoluteString]];
BOOL theResult = [self.persistentObjectManager.database executeExpression:theExpression error:outError];
if (theResult == NO)
	{
	// TODO
	if (outError)
		*outError = [NSError errorWithDomain:@"TODO" code:-1 userInfo:NULL]; 
	return(NULL);
	}

theFeed = [self feedforURL:inURL];
if (theFeed == NULL)
	{
	// TODO
	if (outError)
		*outError = [NSError errorWithDomain:@"TODO" code:-1 userInfo:NULL]; 
	return(NULL);
	}

return(theFeed);
}

- (BOOL)updateFeed:(CFeed *)inFeed completionTicket:(CCompletionTicket *)inCompletionTicket
{
NSURL *theURL = inFeed.url;

if ([self.currentURLs containsObject:theURL] == YES)
	{
	NSLog(@"Already fetching %@, ignoring this request to update.", theURL);
	return(NO);
	}

[inCompletionTicket didBeginForTarget:self];

NSURLRequest *theRequest = [[[NSURLRequest alloc] initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0] autorelease];
CCompletionTicket *theCompletionTicket = [CCompletionTicket completionTicketWithIdentifier:@"FOO" delegate:self userInfo:NULL subTicket:inCompletionTicket];

[self.currentURLs addObject:theURL];

CManagedURLConnection *theConnection = [[[CManagedURLConnection alloc] initWithRequest:theRequest completionTicket:theCompletionTicket] autorelease];
[[CURLConnectionManager instance] addAutomaticURLConnection:theConnection toChannel:@"RSS"];

return(YES);
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
CFeed *theFeed = NULL;

[self.persistentObjectManager.database begin];

CManagedURLConnection *theConnection = (CManagedURLConnection *)inTarget;
[self.currentURLs removeObject:theConnection.request.URL];
CRSSFeedDeserializer *theDeserializer = [[[CRSSFeedDeserializer alloc] initWithData:theConnection.data] autorelease];
for (id theDictionary in theDeserializer)
	{
	if (theDeserializer.error != NULL)
		{
		NSLog(@"ERROR: bailing.");
		break;
		}
		
	ERSSFeedDictinaryType theType = [[theDictionary objectForKey:@"type"] intValue];
	switch (theType)
		{
		case FeedDictinaryType_Feed:
			{
			NSURL *theFeedURL = theConnection.request.URL;
			theFeed = [self feedforURL:theFeedURL];
			// TODO - in theory this will never be null.
			if (theFeed == NULL)
				{
				NSError *theError = NULL;
				theFeed = [self.persistentObjectManager makePersistentObjectOfClass:[CFeed class] error:&theError];
				theFeed.feedStore = self;
				}

			NSError *theError = NULL;
			if ([[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError] == NO)
				[NSException raise:NSGenericException format:@"%@", theError];
			
			theFeed.lastChecked = [NSDate date];
			if ([theFeed write:&theError] == NO)
				[NSException raise:NSGenericException format:@"%@", theError];
			}
			break;
		case FeedDictinaryType_Entry:
			{
			CFeedEntry *theEntry = [theFeed entryForIdentifier:[theDictionary objectForKey:@"identifier"]];
			if (theEntry == NULL)
				{
				NSError *theError = NULL;
				theEntry = [self.persistentObjectManager makePersistentObjectOfClass:[CFeedEntry class] error:&theError];
				theEntry.feed = theFeed;
				}
			
			NSError *theError = NULL;
			[[CFeedEntry objectTranscoder] updateObject:theEntry withPropertiesInDictionary:theDictionary error:&theError];

			[theFeed addEntry:theEntry];

			if ([theEntry write:&theError] == NO)
				[NSException raise:NSGenericException format:@"%@", theError];
			}
			break;
		}
	}

if (theDeserializer.error != NULL)
	{
	NSLog(@"%@", theDeserializer.error);
	
	[self.persistentObjectManager.database rollback];

	[inCompletionTicket.subTicket didFailForTarget:self error:theDeserializer.error];
	}
else
	{
	[self.persistentObjectManager.database commit];
	
	[inCompletionTicket.subTicket didCompleteForTarget:self result:theFeed];
	}

}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError
{
NSLog(@"CFeedstore got an error: %@", inError);

CManagedURLConnection *theConnection = (CManagedURLConnection *)inTarget;
[self.currentURLs removeObject:theConnection.request.URL];

[inCompletionTicket.subTicket didFailForTarget:self error:inError];

}

@end
