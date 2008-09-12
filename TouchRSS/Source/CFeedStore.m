//
//  CFeedStore.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

static CFeedStore *gInstance = NULL;

@interface CFeedStore ()
@property (readwrite, nonatomic, retain) CSqliteDatabase *database;
@end

#pragma mark -

@implementation CFeedStore

@synthesize delegate;
@synthesize database;

+ (CFeedStore *)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	NSString *theApplicationSupportFolder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *thePath = [theApplicationSupportFolder stringByAppendingPathComponent:@"feedstore.db"];
		
	NSError *theError = NULL;

	if (YES)
		{
		NSLog(@"REMOVING FEEDSTORE");
		[[NSFileManager defaultManager] removeItemAtPath:thePath error:&theError];
		}

	if ([[NSFileManager defaultManager] fileExistsAtPath:thePath] == NO)
		{
		[[NSFileManager defaultManager] createDirectoryAtPath:theApplicationSupportFolder withIntermediateDirectories:YES attributes:NULL error:&theError];
		NSString *theSourcePath = [[NSBundle mainBundle] pathForResource:@"feedstore" ofType:@"db"];
		[[NSFileManager defaultManager] copyItemAtPath:theSourcePath toPath:thePath error:&theError];
		}
	
	self.database = [[[CSqliteDatabase alloc] initWithPath:thePath] autorelease];
	[self.database open:&theError];
	if (theError)
		NSLog(@"%@", theError);
	}
return(self);
}

- (void)dealloc
{
self.database = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSInteger)countOfFeeds
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT count() FROM feed"];
NSDictionary *theRow = [self.database rowForExpression:theExpression error:&theError];
return([[theRow objectForKey:@"count()"] integerValue]);
}

- (CFeed *)feedAtIndex:(NSInteger)inIndex
{
// TODO: DO NOT DO THIS: http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM feed LIMIT 1 OFFSET %d", inIndex];
NSDictionary *theDictionary = [self.database rowForExpression:theExpression error:&theError];
CFeed *theFeed = [[[CFeed alloc] initWithFeedStore:self] autorelease];
[[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError];
return(theFeed);
}

- (CFeed *)feedForLink:(NSURL *)inLink
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM feed WHERE link = '%@'", [[inLink absoluteString] encodedForSql]];
NSDictionary *theDictionary = [self.database rowForExpression:theExpression error:&theError];
CFeed *theFeed = [[[CFeed alloc] initWithFeedStore:self] autorelease];

[[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError];

return(theFeed);
}

- (void)update
{
NSError *theError = NULL;
NSEnumerator *theEnumerator = [self.database enumeratorForExpression:@"SELECT link FROM feed" error:&theError];
for (id theRow in theEnumerator)
	{
	NSString *theURLString = [theRow objectForKey:@"link"];
	NSURL *theURL = [NSURL URLWithString:theURLString];

	NSURLRequest *theRequest = [[[NSURLRequest alloc] initWithURL:theURL] autorelease];
	CCompletionTicket *theCompletionTicket = [CCompletionTicket completionTicketWithIdentifier:@"FOO" delegate:self userInfo:NULL];
	CManagedURLConnection *theConnection = [[[CManagedURLConnection alloc] initWithRequest:theRequest completionTicket:theCompletionTicket] autorelease];
	[[CURLConnectionManager instance] addAutomaticURLConnection:theConnection toChannel:@"RSS"];
	}
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
NSLog(@"completionTicket:didCompleteForTarget:result:");

[self.database begin];

CFeed *theFeed = NULL;

CManagedURLConnection *theConnection = (CManagedURLConnection *)inTarget;
CRSSFeedDeserializer *theDeserializer = [[[CRSSFeedDeserializer alloc] initWithData:theConnection.data] autorelease];
for (id theDictionary in theDeserializer)
	{
	if ([[theDictionary objectForKey:@"type"] isEqualToString:@"feed"])
		{
		NSLog(@"FEED");
		
		theFeed = [self feedForLink:theConnection.request.URL];
//		if (theFeed == NULL)
//			{
//			theFeed = [[[CFeed alloc] initWithFeedStore:self] autorelease];
//			}

		NSError *theError = NULL;
		if ([[CFeed objectTranscoder] updateObject:theFeed withPropertiesInDictionary:theDictionary error:&theError] == NO)
			{
			[NSException raise:NSGenericException format:@"%@", theError];
			}
		
		theFeed.lastChecked = [NSDate date];
//		if ([theFeed write:&theError] == NO)
//			{
//			[NSException raise:NSGenericException format:@"%@", theError];
//			}

		NSLog(@"%@", theFeed.title);
		}
	else if ([[theDictionary objectForKey:@"type"] isEqualToString:@"item"])
		{
		NSLog(@"ENTRY");
		CFeedEntry *theEntry = [theFeed entryForIdentifier:[theDictionary objectForKey:@"identifier"]];
		if (theEntry == NULL)
			{
			theEntry = [[[CFeedEntry alloc] initWithFeed:theFeed] autorelease];
			}
		
		NSError *theError = NULL;
		[[CFeedEntry objectTranscoder] updateObject:theEntry withPropertiesInDictionary:theDictionary error:&theError];

		NSLog(@"Entry: %d", theEntry.rowID);
		if ([theEntry write:&theError] == NO)
			{
			[NSException raise:NSGenericException format:@"%@", theError];
			}
		NSLog(@"Entry: %d", theEntry.rowID);
		}
	}
	
[self.database commit];

NSLog(@"COUNT: %d", [self.database countRowsInTable:@"entry" error:NULL]);

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
