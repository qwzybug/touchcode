//
//  CRSSChannel.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CFeed.h"

#import "CFeedStore.h"
#import "CSqliteDatabase.h"
#import "CFeedEntry.h"
#import "NSString_SqlExtensions.h"
#import "CSqliteDatabase_Extensions.h"
#import "CObjectTranscoder.h"
#import "NSDate_SqlExtension.h"
#import "NSString_SqlExtensions.h"

@interface CFeed ()
@property (readwrite, nonatomic, assign) NSInteger rowID;
@property (readwrite, nonatomic, assign) CFeedStore *feedStore;
@end

#pragma mark -

@implementation CFeed

@synthesize rowID, feedStore, title, link, description_, lastChecked;

+ (CObjectTranscoder *)objectTranscoder
{
return([[[CObjectTranscoder alloc] initWithTargetObjectClass:[self class]] autorelease]);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.rowID = -1;
	}
return(self);
}

- (id)initWithFeedStore:(CFeedStore *)inFeedStore
{
if ((self = [self init]) != NULL)
	{
	self.feedStore = inFeedStore;
	}
return(self);
}

- (id)initWithFeedStore:(CFeedStore *)inFeedStore rowID:(NSInteger)inRowID;
{
if ((self = [self initWithFeedStore:inFeedStore]) != NULL)
	{
	self.rowID = inRowID;
	NSError *theError = NULL;
	if ([self read:&theError] == NO)
		{
		NSLog(@"%@", theError);
		}
	}
return(self);
}

- (void)dealloc
{
self.feedStore = NULL;
self.title = NULL;
self.link = NULL;
self.description_ = NULL;
//
[super dealloc];
}

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex
{
// TODO: DO NOT DO THIS: http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM entry LIMIT 1 OFFSET %d", inIndex];
NSArray *theRows = [self.feedStore.database rowsForExpression:theExpression error:&theError];
NSDictionary *theDictionary = [theRows objectAtIndex:0];
CFeedEntry *theFeed = [[[CFeedEntry alloc] initWithFeed:self] autorelease];
[[[self class] objectTranscoder] updateObject:self withPropertiesInDictionary:theDictionary error:&theError];

return(theFeed);
}

- (CFeedEntry *)entryForIdentifier:(NSString *)inIdentifier
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM entry WHERE feed_id = %d AND identifier = '%@' LIMIT 1", self.rowID, [inIdentifier encodedForSql]];
NSDictionary *theDictionary = [self.feedStore.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	return(NULL);
CFeedEntry *theFeed = [[[CFeedEntry alloc] initWithFeed:self] autorelease];
[[[self class] objectTranscoder] updateObject:self withPropertiesInDictionary:theDictionary error:&theError];

return(theFeed);
}

- (BOOL)read:(NSError **)outError
{
CSqliteDatabase *theDatabase = self.feedStore.database;

NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM feed WHERE id = %d", self.rowID];
NSDictionary *theDictionary = [theDatabase rowForExpression:theExpression error:outError];
[[[self class] objectTranscoder] updateObject:self withPropertiesInDictionary:theDictionary error:outError];
return(YES);
}

- (BOOL)write:(NSError **)outError
{
CSqliteDatabase *theDatabase = self.feedStore.database;

if (self.rowID == -1)
	{
	NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO feed (title, link, description, lastChecked) VALUES ('%@', '%@', '%@', '%@')", [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.description_ encodedForSql], [self.lastChecked sqlDateString]];

	BOOL theResult = [theDatabase executeExpression:theExpression error:outError];
	if (theResult == NO)
		{
		return(NO);
		}

	theExpression = [NSString stringWithFormat:@"SELECT id FROM feed WHERE (link = %@)", [[self.link absoluteString] encodedForSql]];
	NSDictionary *theRow = [theDatabase rowForExpression:theExpression error:outError];
	if (theResult == NO)
		{
		return(NO);
		}

	self.rowID = [[theRow objectForKey:@"id"] integerValue];
	}
else
	{
	NSLog(@"PASS");
	}

return(YES);
}

@end
