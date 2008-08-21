//
//  CNetworkActivityManager.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNetworkActivityManager : NSObject {
	NSInteger networkActivityCount;
}

+ (CNetworkActivityManager *)instance;

@property (readwrite, assign) NSInteger networkActivityCount;

@end
