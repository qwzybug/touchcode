//
//  CFeedFetcher.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/5/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCompletionTicket.h"

@class CFeedStore;
@class CRSSFeedDeserializer;
@class CFeed;

@protocol CFeedFetcherDelegate;

@interface CFeedFetcher : NSObject <CCompletionTicketDelegate> {
	CFeedStore *feedStore; // Never retained.
	id <CFeedFetcherDelegate> delegate;
	NSTimeInterval fetchInterval;
	//
	NSTimer *fetchTimer;
	NSMutableSet *currentURLs;
}

@property (readonly, nonatomic, assign) CFeedStore *feedStore;
@property (readwrite, nonatomic, assign) id <CFeedFetcherDelegate> delegate;
@property (readwrite, nonatomic, assign) NSTimeInterval fetchInterval;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore;

- (CRSSFeedDeserializer *)deserializerForData:(NSData *)inData;
- (CFeed *)subscribeToURL:(NSURL *)inURL error:(NSError **)outError;
- (BOOL)updateFeed:(CFeed *)inFeed;
- (BOOL)updateFeed:(CFeed *)inFeed completionTicket:(CCompletionTicket *)inCompletionTicket;
- (void)cancel;

@end

#pragma mark -

@protocol CFeedFetcherDelegate <NSObject>

@optional
- (BOOL)feedFetcher:(CFeedFetcher *)inFeedFetcher shouldFetchFeed:(CFeed *)inFeed;
- (void)feedFetcher:(CFeedFetcher *)inFeedFetcher didFetchFeed:(CFeed *)inFeed;
- (void)feedFetcher:(CFeedFetcher *)inFeedFetcher didFailFetchingFeed:(CFeed *)inFeed withError:(NSError *)inError;

@end
