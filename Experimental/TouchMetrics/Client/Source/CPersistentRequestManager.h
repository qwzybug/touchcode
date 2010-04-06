//
//  CPersistentRequestManager.h
//  Uploadr
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCoreDataManager.h"

@interface CPersistentRequestManager : NSObject <CCoreDataManagerDelegate> {
	CCoreDataManager *coreDataManager;
	NSOperationQueue *operationQueue;
	NSTimer *scanTimer;
}

- (void)addRequest:(NSURLRequest *)inRequest;

@end
