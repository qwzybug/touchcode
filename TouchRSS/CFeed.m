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

@interface CFeed ()
@property (readwrite, nonatomic, assign) NSInteger rowID;
@property (readwrite, nonatomic, assign) CFeedStore *feedStore;
@end

#pragma mark -

@implementation CFeed

@synthesize rowID, feedStore, title, link, description_;

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

- (id)initWithFeedStore:(CFeedStore *)inFeedStore dictionary:(NSDictionary *)inDictionary
{
if ((self = [self initWithFeedStore:inFeedStore]) != NULL)
	{
	if ([inDictionary objectForKey:@"title"])
		self.title = [inDictionary objectForKey:@"title"];
	if ([inDictionary objectForKey:@"link"])
		self.link = [inDictionary objectForKey:@"link"];
	if ([inDictionary objectForKey:@"description_"])
		self.description_ = [inDictionary objectForKey:@"description_"];
	}
return(self);
}


- (id)initWithFeedStore:(CFeedStore *)inFeedStore rowID:(NSInteger)inRowID;
{
if ((self = [self initWithFeedStore:inFeedStore]) != NULL)
	{
	self.rowID = inRowID;	
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
CFeedEntry *theFeed = [[[CFeedEntry alloc] initWithFeed:self dictionary:theDictionary] autorelease];
return(theFeed);
}

- (BOOL)write:(NSError **)outError
{
CSqliteDatabase *theDatabase = self.feedStore.database;

NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO entry (title, link, description) VALUES ('%@', '%@', '%@')", [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.description_ encodedForSql]];

BOOL theResult = [theDatabase executeExpression:theExpression error:outError];
if (theResult == NO)
	{
	return(NO);
	}

theExpression = [NSString stringWithFormat:@"SELECT id FROM entry WHERE (link = %@)", [[self.link absoluteString] encodedForSql]];
NSDictionary *theRow = [theDatabase rowForExpression:theExpression error:outError];
if (theResult == NO)
	{
	return(NO);
	}

self.rowID = [[theRow objectForKey:@"id"] integerValue];

return(theResult);
}

@end
