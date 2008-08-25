//
//  NSObject_InvocationGrabberExtensions.h
//  InvocationGrabber
//
//  Created by Jonathan Wight on 8/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_InvocationGrabberExtensions)

- (id)grabInvocation:(NSInvocation **)outInvocation;

- (id)grabInvocationAndPerformOnMainThreadWaitUntilDone:(BOOL)inWaitUntilDone;

@end
