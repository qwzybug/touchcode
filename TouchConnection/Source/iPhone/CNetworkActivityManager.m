//
//  CNetworkActivityManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
@synchronized(self)
	{
	if (gInstance == NULL)
		gInstance = [[self alloc] init];
	}
return(gInstance);
}

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
[self instance];
//
[thePool release];
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

#pragma mark -

- (NSInteger)networkActivityCount
{
return(networkActivityCount);
}

- (void)setNetworkActivityCount:(NSInteger)inNetworkActivityCount
{
if (networkActivityCount != inNetworkActivityCount)
	{
	networkActivityCount = inNetworkActivityCount;

	[UIApplication sharedApplication].networkActivityIndicatorVisible = (networkActivityCount > 0) ? YES : NO;
	} 
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
