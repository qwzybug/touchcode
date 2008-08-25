//
//  CInvocationGrabber.m
//
//  Created by Jonathan Wight on 03/16/2006.
//  Copyright 2006 Toxic Software Inc., All rights reserved.
//

#import "CInvocationGrabber.h"

/*
CInvocationGrabber *theInvocationGrabber = [CInvocationGrabber invocationGrabber];
[[theInvocationGrabber prepareWithInvocationTarget:foo] doSomethingWithParameter:bar];
NSInvocation *theInvocation = [theInvocationGrabber invocation];
*/

@interface CInvocationGrabber ()
@property (readwrite, retain) id target;
@property (readwrite, assign) NSInvocation **invocationDestination;
@end

@implementation CInvocationGrabber

@synthesize target;
@synthesize invocationDestination;

+ (id)grabInvocation:(NSInvocation **)outInvocation fromTarget:(id)inTarget;
{
CInvocationGrabber *theGrabber = [[[self alloc] init] autorelease];
theGrabber.target = inTarget;
theGrabber.invocationDestination = outInvocation;
return(theGrabber);
}

- (id)init
{
return(self);
}

- (void)dealloc
{
self.target = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)inSelector
{
NSMethodSignature *theMethodSignature = [[self target] methodSignatureForSelector:inSelector];
return(theMethodSignature);
}

- (void)forwardInvocation:(NSInvocation *)ioInvocation
{
[ioInvocation setTarget:self.target];

if (self.invocationDestination)
	*self.invocationDestination = ioInvocation;

[self didGrabInvocation:ioInvocation];
}

- (void)didGrabInvocation:(NSInvocation *)inInvocation
{
}

@end

#pragma mark  -

@interface CThreadingInvocationGrabber ()
@property (readwrite, nonatomic, assign) BOOL waitUntilDone;
@end

#pragma mark -

@implementation CThreadingInvocationGrabber

@synthesize waitUntilDone;

+ (id)grabInvocationFromTarget:(id)inTarget andPeformOnMainThreadWaitUntilDone:(BOOL)inWaitUntilDone
{
CThreadingInvocationGrabber *theGrabber = [[[self alloc] init] autorelease];
theGrabber.target = inTarget;
theGrabber.waitUntilDone = inWaitUntilDone;
return(theGrabber);
}

- (void)didGrabInvocation:(NSInvocation *)inInvocation
{
[inInvocation retainArguments];

[inInvocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:self.waitUntilDone];
}

@end

