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

#define ALWAYS_RESET_DATABASE 1

static CFeedStore *gInstance = NULL;

@interface CFeedStore ()
@property (readwrite, nonatomic, retain) CSqliteDatabase *database;
@end

#pragma mark -

@implementation CFeedStore

@synthesize delegate;
@dynamic databasePath;
@dynamic database;

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
	}
return(self);
}

- (void)dealloc
{
self.delegate = NULL;
self.databasePath = NULL;
self.database = NULL;
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

- (CSqliteDatabase *)database
{
if (database == NULL)
	{
	NSError *theError = NULL;

	#if ALWAYS_RESET_DATABASE == 1
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath] == YES)
		{
		NSLog(@"REMOVING FEEDSTORE");
		if ([[NSFileManager defaultManager] removeItemAtPath:self.databasePath error:&theError] == NO)
			[NSException raise:NSGenericException format:@"%@", theError];
		}
	#endif /* ALWAYS_RESET_DATABASE == 1 */
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath] == NO)
		{
		if ([[NSFileManager defaultManager] createDirectoryAtPath:[self.databasePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:NULL error:&theError] == NO)
			[NSException raise:NSGenericException format:@"%@", theError];

		NSString *theSourcePath = [[NSBundle mainBundle] pathForResource:@"feedstore" ofType:@"db"];
		if ([[NSFileManager defaultManager] copyItemAtPath:theSourcePath toPath:self.databasePath error:&theError] == NO)
			[NSException raise:NSGenericException format:@"%@", theError];
		}
	
	CSqliteDatabase *theDatabase = [[[CSqliteDatabase alloc] initWithPath:self.databasePath] autorelease];
	[theDatabase open:&theError];
	if (theError)
		[NSException raise:NSGenericException format:@"%@", theError];

	database = [theDatabase retain];
	}
return(database); 
}

- (void)setDatabase:(CSqliteDatabase *)inDatabase
{
if (database != inDatabase)
	{
	[database autorelease];
	database = [inDatabase retain];
    }
}

#pragma mark -

- (NSInteger)countOfFeeds
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT count() FROM feed"];
NSDictionary *theRow = [self.database rowForExpression:theExpression error:&theError];
if (theRow == NULL)
	[NSException raise:NSGenericException format:@"%@", theError];
return([[theRow objectForKey:@"count()"] integerValue]);
}

- (CFeed *)feedAtIndex:(NSInteger)inIndex
{
// TODO: DO NOT DO THIS: http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM feed LIMIT 1 OFFSET %d", inIndex];
NSDictionary *theDictionary = [self.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	[NSException raise:NSGenericException format:@"%@", theError];
CFeed *theFeed = [[[CFeed alloc] initWithFeedStore:self] autorelease];
if ([[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError] == NO)
	[NSException raise:NSGenericException format:@"%@", theError];
return(theFeed);
}

- (CFeed *)feedforURL:(NSURL *)inURL
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM feed WHERE url = '%@'", [[inURL absoluteString] encodedForSql]];
NSDictionary *theDictionary = [self.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	[NSException raise:NSGenericException format:@"%@", theError];
CFeed *theFeed = [[[CFeed alloc] initWithFeedStore:self] autorelease];

if ([[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError] == NO)
	[NSException raise:NSGenericException format:@"%@", theError];

return(theFeed);
}

- (BOOL)update:(NSError **)outError
{
NSEnumerator *theEnumerator = [self.database enumeratorForExpression:@"SELECT url FROM feed" error:outError];
if (theEnumerator == NULL)
	return(NO);
for (id theRow in theEnumerator)
	{
	NSString *theURLString = [theRow objectForKey:@"url"];
	NSURL *theURL = [NSURL URLWithString:theURLString];

	NSURLRequest *theRequest = [[[NSURLRequest alloc] initWithURL:theURL] autorelease];
	CCompletionTicket *theCompletionTicket = [CCompletionTicket completionTicketWithIdentifier:@"FOO" delegate:self userInfo:NULL];
	CManagedURLConnection *theConnection = [[[CManagedURLConnection alloc] initWithRequest:theRequest completionTicket:theCompletionTicket] autorelease];
	[[CURLConnectionManager instance] addAutomaticURLConnection:theConnection toChannel:@"RSS"];
	}
return(YES);
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
NSLog(@"completionTicket:didCompleteForTarget:result:");

CFeed *theFeed = NULL;

[self.database begin];

CManagedURLConnection *theConnection = (CManagedURLConnection *)inTarget;
CRSSFeedDeserializer *theDeserializer = [[[CRSSFeedDeserializer alloc] initWithData:theConnection.data] autorelease];
for (id theDictionary in theDeserializer)
	{
	ERSSFeedDictinaryType theType = [[theDictionary objectForKey:@"type"] intValue];
	switch (theType)
		{
		case RSSFeedDictinaryType_Feed:
			{
			NSURL *theFeedURL = theConnection.request.URL;
			theFeed = [self feedforURL:theFeedURL];
			if (theFeed == NULL)
				theFeed = [[[CFeed alloc] initWithFeedStore:self] autorelease];

			NSError *theError = NULL;
			if ([[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError] == NO)
				[NSException raise:NSGenericException format:@"%@", theError];
			
			theFeed.lastChecked = [NSDate date];
			if ([theFeed write:&theError] == NO)
				[NSException raise:NSGenericException format:@"%@", theError];
			}
			break;
		case RSSFeedDictinaryType_Entry:
			{
			CFeedEntry *theEntry = [theFeed entryForIdentifier:[theDictionary objectForKey:@"identifier"]];
			if (theEntry == NULL)
				theEntry = [[[CFeedEntry alloc] initWithFeed:theFeed] autorelease];
			
			NSError *theError = NULL;
			[[CFeedEntry objectTranscoder] updateObject:theEntry withPropertiesInDictionary:theDictionary error:&theError];

			if ([theEntry write:&theError] == NO)
				[NSException raise:NSGenericException format:@"%@", theError];
			}
			break;
		}
	}

[self.database commit];

[self.delegate feedStore:self didUpdateFeed:theFeed];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError
{
NSLog(@"ERROR: %@", inError);
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget
{
NSLog(@"CANCEL");
}


@end
