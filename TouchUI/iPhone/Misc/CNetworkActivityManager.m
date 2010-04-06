//
//  CNetworkActivityManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/16/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CNetworkActivityManager.h"

static CNetworkActivityManager *gInstance = NULL;

@interface CNetworkActivityManager ()
@property (readwrite, assign) NSInteger count;
@property (readwrite, assign) NSTimer *delayTimer;

- (void)delayTimer:(NSTimer *)inTimer;
@end

#pragma mark -

@implementation CNetworkActivityManager

@dynamic count;
@synthesize delay;
@synthesize delayTimer;

+ (id)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	delay = 0.2;
	}
return(self);
}

- (void)dealloc
{
[delayTimer invalidate];
delayTimer = NULL;
//
[super dealloc];
}

- (NSInteger)count
{
return(count);
}

- (void)setCount:(NSInteger)inCount
{
if (count != inCount)
	{
	if (count <= 0 && inCount > 0)
		{
		if (self.delayTimer != NULL)
			{
			[self.delayTimer invalidate];
			self.delayTimer = NULL;
			}
		self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:self.delay target:self selector:@selector(delayTimer:) userInfo:[NSNumber numberWithBool:YES] repeats:NO];
		}
	else if (count > 0 && inCount <= 0)
		{
		if (self.delayTimer != NULL)
			{
			[self.delayTimer invalidate];
			self.delayTimer = NULL;
			}
		self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:self.delay target:self selector:@selector(delayTimer:) userInfo:[NSNumber numberWithBool:NO] repeats:NO];
		}

	count = inCount;
	}
}

- (void)addNetworkActivity
{
self.count++;
}

- (void)removeNetworkActivity
{
self.count--;
}

- (void)delayTimer:(NSTimer *)inTimer
{
self.delayTimer = NULL;

[UIApplication sharedApplication].networkActivityIndicatorVisible = [inTimer.userInfo boolValue];
}

@end
