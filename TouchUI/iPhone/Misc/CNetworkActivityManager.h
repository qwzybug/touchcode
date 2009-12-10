//
//  CNetworkActivityManager.h
//  TouchCode
//
//  Created by Jonathan Wight on 11/16/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNetworkActivityManager : NSObject {
	NSInteger count;
	NSTimeInterval delay;
	NSTimer *delayTimer;
}

@property (readonly, assign) NSInteger count;
@property (readwrite, assign) NSTimeInterval delay;

+ (CNetworkActivityManager *)instance;

- (void)addNetworkActivity;
- (void)removeNetworkActivity;

@end
