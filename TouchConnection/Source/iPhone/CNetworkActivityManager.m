//
//  CNetworkActivityManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CNetworkActivityManager.h"

static NSString *const kWebViewLoading = @"kWebViewLoading";

static CNetworkActivityManager *gInstance = NULL;

@interface CNetworkActivityManager ()
@end

#pragma mark -

@implementation CNetworkActivityManager

@dynamic networkActivityCount;

+ (CNetworkActivityManager *)instance
{
if (gInstance == NULL)
	gInstance = [[self alloc] init];
return(gInstance);
}

#pragma mark -

- (void)dealloc
{
//
[super dealloc];
}

#pragma mark 0

- (NSInteger)networkActivityCount
{
return(networkActivityCount);
}

- (void)setNetworkActivityCount:(NSInteger)inNetworkActivityCount
{
networkActivityCount = inNetworkActivityCount;

[UIApplication sharedApplication].networkActivityIndicatorVisible = (networkActivityCount > 0) ? YES : NO;
}

@end
