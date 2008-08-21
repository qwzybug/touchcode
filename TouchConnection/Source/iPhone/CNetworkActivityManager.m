//
//  CNetworkActivityManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CNetworkActivityManager.h"

#import "CURLConnectionManager.h"

static NSString *const kActiveConnectionCountContext = @"kActiveConnectionCountContext";

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

- (id)init
{
if ((self = [super init]) != NULL)
	{
	[[CURLConnectionManager instance] addObserver:self forKeyPath:@"activeConnectionCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:kActiveConnectionCountContext];
	}
return(self);
}

- (void)dealloc
{
[[CURLConnectionManager instance] removeObserver:self forKeyPath:@"activeConnectionCount"];
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

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
if (context == kActiveConnectionCountContext)
	{
	NSInteger theNew = 0;
	id theNewValue = [change valueForKey:NSKeyValueChangeNewKey];
	if (theNewValue && theNewValue != [NSNull null])
		theNew = [theNewValue integerValue];

	NSInteger theOld = 0;
	id theOldValue = [change valueForKey:NSKeyValueChangeOldKey];
	if (theOldValue && theOldValue != [NSNull null])
		theOld = [theOldValue integerValue];
		
	self.networkActivityCount += theNew - theOld;
	}
else
	{
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
