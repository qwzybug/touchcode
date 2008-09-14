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
#import "CPersistentObjectManager.h"

@interface CFeedEntry ()
@end

#pragma mark -

@implementation CFeedEntry

@synthesize feed, identifier, title, content, link, subtitle, updated;

+ (NSString *)tableName
{
return(@"entry");
}

- (void)dealloc
{
self.feed = NULL;
self.identifier = NULL;
self.title = NULL;
self.link = NULL;
self.subtitle = NULL;
self.updated = NULL;
//
[super dealloc];
}

#pragma mark -

- (BOOL)write:(NSError **)outError
{
CSqliteDatabase *theDatabase = self.persistentObjectManager.database;

if (self.rowID == -1)
	{
	NSString *theExpression = [NSString stringWithFormat:@"INSERT INTO entry (feed_id, identifier, title, link, subtitle, content, updated) VALUES (%d, '%@', '%@', '%@', '%@', '%@', '%@')", self.feed.rowID, [self.identifier encodedForSql], [self.title encodedForSql], [[self.link absoluteString] encodedForSql], [self.subtitle encodedForSql], [self.content encodedForSql], [self.updated sqlDateString]];
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
