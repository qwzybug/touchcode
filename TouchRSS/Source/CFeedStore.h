//
//  CFeedStore.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCompletionTicket.h"

@class CSqliteDatabase;
@class CFeed;

@protocol CFeedStoreDelegate;

@interface CFeedStore : NSObject <CCompletionTicketDelegate> {
	id <CFeedStoreDelegate> delegate;
	CSqliteDatabase *database;
}

@property (readwrite, nonatomic, assign) id <CFeedStoreDelegate> delegate;
@property (readonly, nonatomic, retain) CSqliteDatabase *database;

+ (CFeedStore *)instance;

- (NSInteger)countOfFeeds;
- (CFeed *)feedAtIndex:(NSInteger)inIndex;
- (CFeed *)feedForLink:(NSURL *)inLink;

- (void)update;

@end

#pragma mark -

@protocol CFeedStoreDelegate

@optional
- (void)feedStore:(CFeedStore *)inFeedStore didUpdateFeed:(CFeed *)inFeed;

@end