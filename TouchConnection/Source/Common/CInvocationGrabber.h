//
//  CInvocationGrabber.h
//
//  Created by Jonathan Wight on 03/16/2006.
//  Copyright 2006 Toxic Software Inc., All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class CInvocationGrabber
 * @discussion CInvocationGrabber is a helper object that makes it very easy to construct instances of NSInvocation. The object is inspired by NSUndoManager's prepareWithInvocationTarget method.

NSInvocation *theInvocation = NULL;
[[CInvocationGrabber grabWithTarget:someObject invocation:&theInvocation] doSomethingWithParameter:someParameter];

Note this version is all new and the syntax is a lot more compact. This version is not backwards compatible and the old version is therefore deprecated.

WARNING: Does not seem to work with methods that take vararg style arguments (...), e.g. -[NSMutableString appendFormat:] etc.
 */
@interface CInvocationGrabber : NSProxy {
	id target;
	NSInvocation **invocationDestination;
}

+ (id)grabInvocation:(NSInvocation **)outInvocation fromTarget:(id)inTarget;

- (void)didGrabInvocation:(NSInvocation *)inInvocation;

@end

#pragma mark -

@interface CThreadingInvocationGrabber : CInvocationGrabber {
	BOOL waitUntilDone;
}

+ (id)grabInvocationFromTarget:(id)inTarget andPeformOnMainThreadWaitUntilDone:(BOOL)inWaitUntilDone;

@end

