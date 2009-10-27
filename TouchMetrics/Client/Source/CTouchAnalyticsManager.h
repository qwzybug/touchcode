//
//  CTouchAnalyticsManager.h
//  Uploadr
//
//  Created by Jonathan Wight on 10/23/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCoreDataManager.h"

@class CCoreDataManager;
@class CPersistentRequestManager;

@interface CTouchAnalyticsManager : NSObject <CCoreDataManagerDelegate> {
	CCoreDataManager *coreDataManager;
	NSOperationQueue *operationQueue;
	CPersistentRequestManager *requestManager;
}

@property (readonly, nonatomic, retain) CCoreDataManager *coreDataManager;
@property (readonly, nonatomic, retain) NSOperationQueue *operationQueue;
@property (readonly, nonatomic, retain) CPersistentRequestManager *requestManager;

+ (CTouchAnalyticsManager *)instance;

- (void)postMessage:(NSDictionary *)inMessage;

- (void)processMessages;

@end
