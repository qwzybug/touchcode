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
#import "CObjectTranscoder.h"
#import "NSDate_SqlExtension.h"
#import "NSString_SqlExtensions.h"

@interface CFeed ()
@property (readwrite, nonatomic, assign) NSInteger rowID;
@property (readwrite, nonatomic, assign) CFeedStore *feedStore;
@end

#pragma mark -

@implementation CFeed

@synthesize rowID, feedStore, updating, url, title, link, description_, lastChecked;

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
self.url = NULL;
self.title = NULL;
self.link = NULL;
self.description_ = NULL;
self.lastChecked = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSInteger)countOfEntries
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT count() FROM entry WHERE feed_id = %d", self.rowID];
NSDictionary *theDictionary = [self.feedStore.database rowForExpression:theExpression error:&theError];
return([[theDictionary objectForKey:@"count()"] intValue]);
}

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex
{
// TODO: DO NOT DO THIS: http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor

NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM entry WHERE feed_id = %d ORDER BY publicationDate DESC LIMIT 1 OFFSET %d", self.rowID, inIndex];
NSDictionary *theDictionary = [self.feedStore.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	return(NULL);
CFeedEntry *theFeedEntry = [[[CFeedEntry alloc] initWithFeed:self] autorelease];
[[[theFeedEntry class] objectTranscoder] updateObject:theFeedEntry withPropertiesInDictionary:theDictionary error:&theError];

return(theFeedEntry);
}

- (CFeedEntry *)entryForIdentifier:(NSString *)inIdentifier
{
NSError *theError = NULL;
NSString *theExpression = [NSString stringWithFormat:@"SELECT * FROM entry WHERE feed_id = %d AND identifier = '%@' LIMIT 1", self.rowID, [inIdentifier encodedForSql]];
NSDictionary *theDictionary = [self.feedStore.database rowForExpression:theExpression error:&theError];
if (theDictionary == NULL)
	return(NULL);
CFeedEntry *theFeedEntry = [[[CFeedEntry alloc] initWithFeed:self] autorelease];
[[[theFeedEntry class] objectTranscoder] updateObject:theFeedEntry withPropertiesInDictionary:theDictionary error:&theError];

return(theFeedEntry);
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
	NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO feed (url, title, link, description, lastChecked) VALUES ('%@', '%@', '%@', '%@', '%@')", [[self.url absoluteString] encodedForSql], [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.description_ encodedForSql], [self.lastChecked sqlDateString]];

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
	NSLog(@"PASS");
	}

return(YES);
}

@end
