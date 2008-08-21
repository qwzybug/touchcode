//
//  CNetworkActivityManager.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Keeps track of number of active network connections. If the count is more than 0 it will automatically the connectivity spinner in the status bar. It automatically keeps track of CURLConnectionManager for you. */
@interface CNetworkActivityManager : NSObject {
	NSInteger networkActivityCount;
}

+ (CNetworkActivityManager *)instance;

@property (readwrite, assign) NSInteger networkActivityCount;

@end
