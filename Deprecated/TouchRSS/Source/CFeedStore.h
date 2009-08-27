//
//  CFeedStore.h
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

#import <Foundation/Foundation.h>

@class CSqliteDatabase;
@class CFeed;
@class CPersistentObjectManager;
@class CRSSFeedDeserializer;
@class CFeedFetcher;

@interface CFeedStore : NSObject {
	NSString *databasePath;
	CPersistentObjectManager *persistentObjectManager;
	NSMutableArray *mutableFeeds;
	CFeedFetcher *feedFetcher;
}

@property (readwrite, nonatomic, retain) NSString *databasePath;
@property (readonly, nonatomic, retain) CPersistentObjectManager *persistentObjectManager;
@property (readonly, nonatomic, retain) CFeedFetcher *feedFetcher;
@property (readonly, nonatomic, retain) NSArray *feeds;

+ (Class)feedClass;
+ (Class)feedEntryClass;

- (NSInteger)countOfFeeds;
- (CFeed *)feedAtIndex:(NSInteger)inIndex;
- (CFeed *)feedforURL:(NSURL *)inURL;
- (NSArray *)entriesForFeeds:(NSArray *)inFeeds;
- (NSArray *)entriesForFeeds:(NSArray *)inFeeds sortByColumn:(NSString *)inColumn descending:(BOOL)inDescending limit:(NSInteger)inLimit;

@end
