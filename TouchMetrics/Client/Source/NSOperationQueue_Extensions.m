//
//  NSOperationQueue_Extensions.m
//  Uploadr
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "NSOperationQueue_Extensions.h"

@interface CRunloopHelper : NSObject {
	BOOL flag;
}
@property (readwrite, assign) BOOL flag;
- (void)runSynchronousOperation:(NSOperation *)inOperation onQueue:(NSOperationQueue *)inQueue;
@end

#pragma mark -

@implementation NSOperationQueue (NSOperationQueue_Extensions)

- (void)runSynchronousOperation:(NSOperation *)inOperation
{
CRunloopHelper *theHelper = [[[CRunloopHelper alloc] init] autorelease];
[theHelper runSynchronousOperation:inOperation onQueue:self];
}

@end

#pragma mark -

@implementation CRunloopHelper

@synthesize flag;

- (void)runSynchronousOperation:(NSOperation *)inOperation onQueue:(NSOperationQueue *)inQueue
{
NSString *theContext = @"-[CRunloopHelper runSynchronousOperation:onQueue] context";

[inOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:theContext];
[inOperation addObserver:self forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:theContext];

[inQueue addOperation:inOperation];

self.flag = YES;
while (self.flag == YES)
	{
	if ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]] == NO)
		break;
	}

[inOperation removeObserver:self forKeyPath:@"isFinished"];
[inOperation removeObserver:self forKeyPath:@"isCancelled"];
}

- (void)stop
{
self.flag = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
[[NSRunLoop currentRunLoop] performSelector:@selector(stop) target:self argument:NULL order:0 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

@end