//
//  NSObject_InvocationGrabberExtensions.m
//  InvocationGrabber
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSObject_InvocationGrabberExtensions.h"

#import "CInvocationGrabber.h"

@implementation NSObject (NSObject_InvocationGrabberExtensions)

- (id)grabInvocation:(NSInvocation **)outInvocation;
{
return([CInvocationGrabber grabInvocation:outInvocation fromTarget:self]);
}

- (id)grabInvocationAndPerformOnMainThreadWaitUntilDone:(BOOL)inWaitUntilDone
{
return([CThreadingInvocationGrabber grabInvocationFromTarget:self andPeformOnMainThreadWaitUntilDone:inWaitUntilDone]);
}

@end
