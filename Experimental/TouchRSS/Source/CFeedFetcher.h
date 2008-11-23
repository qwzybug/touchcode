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

@interface CFeedFetcher : NSObject <CCompletionTicketDelegate> {
	CFeedStore *feedStore; // Never retained.
	NSMutableSet *currentURLs;
}

@property (readonly, nonatomic, assign) CFeedStore *feedStore;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore;

- (CRSSFeedDeserializer *)deserializerForData:(NSData *)inData;
- (CFeed *)subscribeToURL:(NSURL *)inURL error:(NSError **)outError;
- (BOOL)updateFeed:(CFeed *)inFeed completionTicket:(CCompletionTicket *)inCompletionTicket;
- (void)cancel;

@end
