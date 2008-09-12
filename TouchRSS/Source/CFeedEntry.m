//
//  CRSSItem.m
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

#import "CFeedEntry.h"

#import "NSString_SqlExtensions.h"
#import "CFeed.h"
#import "CFeedStore.h"
#import "NSDate_SqlExtension.h"
#import "CSqliteDatabase.h"
#import "CSqliteDatabase_Extensions.h"
#import "CObjectTranscoder.h"

@interface CFeedEntry ()
@property (readwrite, nonatomic, assign) int rowID;
@property (readwrite, nonatomic, assign) CFeed *feed;
@end

#pragma mark -

@implementation CFeedEntry

@synthesize rowID, feed, identifier, title, link, description_, publicationDate;

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

- (id)initWithFeed:(CFeed *)inFeed rowID:(NSInteger)inRowID
{
if ((self = [self initWithFeed:inFeed]) != NULL)
	{
	self.rowID = inRowID;
	}
return(self);
}

- (id)initWithFeed:(CFeed *)inFeed
{
if ((self = [self init]) != NULL)
	{
	self.feed = inFeed;
	}
return(self);
}

- (void)dealloc
{
self.feed = NULL;
self.identifier = NULL;
self.title = NULL;
self.link = NULL;
self.description_ = NULL;
self.publicationDate = NULL;
//
[super dealloc];
}

#pragma mark -

- (BOOL)write:(NSError **)outError
{
CSqliteDatabase *theDatabase = self.feed.feedStore.database;

if (self.rowID == -1)
	{
	NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO entry (feed_id, identifier, title, link, description, publicationDate) VALUES (%d, '%@', '%@', '%@', '%@', '%@')", self.feed.rowID, [self.identifier encodedForSql], [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.description_ encodedForSql], [self.publicationDate sqlDateString]];
	BOOL theResult = [theDatabase executeExpression:theExpression error:outError];
	if (theResult == NO)
		{
		return(NO);
		}

	theExpression = [NSString stringWithFormat:@"SELECT id FROM entry WHERE (feed_id = %d AND identifier = '%@')", self.feed.rowID, [self.identifier encodedForSql]];
	NSDictionary *theRow = [theDatabase rowForExpression:theExpression error:outError];
	if (theResult == NO)
		{
		return(NO);
		}

	self.rowID = [[theRow objectForKey:@"id"] integerValue];
	}
else
	{
	// TODO -- This should be an update operation.
	}

return(YES);
}


@end
