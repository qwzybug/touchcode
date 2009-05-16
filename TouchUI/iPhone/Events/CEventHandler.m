//
//  CEventHandler.m
//  Test
//
//  Created by Jonathan Wight on 04/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CEventHandler.h"

#import "Geometry.h"

@interface CEventHandler ()

@property (readwrite, nonatomic, assign) NSTimeInterval beginningTime;
@property (readwrite, nonatomic, assign) NSUInteger beginningTouchCount;
@property (readwrite, nonatomic, assign) CGPoint beginningLocation;
@property (readwrite, nonatomic, assign) CGFloat beginningPinchWidth;
@property (readwrite, nonatomic, assign) BOOL isDrag;

@property (readwrite, nonatomic, assign) NSSet *currentTouches;
@property (readwrite, nonatomic, assign) UIEvent *currentEvent;

@end

#pragma mark -

@implementation CEventHandler

@synthesize delegate;
@synthesize view;
@synthesize flickThreshold;
@synthesize beginningTime;
@synthesize beginningTouchCount;
@synthesize beginningLocation;
@synthesize beginningPinchWidth;
@synthesize isDrag;
@synthesize currentTouches;
@synthesize currentEvent;

- (id)init
{
if ((self = [super init]) != nil)
	{
	self.flickThreshold = 1000.0;
	}
return(self);
}

- (void)dealloc
{
self.delegate = NULL;
self.view = NULL;
self.currentTouches = NULL;
self.currentEvent = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
const NSInteger theCount = inTouches.count;
self.beginningTouchCount = theCount;

self.beginningTime = inEvent.timestamp;

self.isDrag = NO;
self.currentTouches = inTouches;
self.currentEvent = inEvent;

if (theCount >= 2)
	{
	NSArray *theTouches = inTouches.allObjects;
	const CGPoint theStart = [[theTouches objectAtIndex:0] locationInView:self.view];
	const CGPoint theEnd = [[theTouches objectAtIndex:1] locationInView:self.view];
	const CGFloat theDistance = distance(theStart, theEnd);
	self.beginningPinchWidth = theDistance;
	
	[self pinchBegan];
	}
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
const NSInteger theCount = inTouches.count;
if (self.beginningTouchCount == 2 && theCount < 2)
	return;

self.currentTouches = inTouches;
self.currentEvent = inEvent;

if (theCount == 1)
	{
	const CGPoint theLocation = [[inTouches anyObject] locationInView:[[inTouches anyObject] view]];
	if (self.isDrag == NO && distance(self.beginningLocation, theLocation) > 10.0)
		{
		self.isDrag = YES;
		[self dragBegan];
		}
	if (self.isDrag == YES)
		[self dragMoved];
	}
else if (theCount >= 2)
	{
	NSArray *theTouches = inTouches.allObjects;

	const CGPoint theStart = [[theTouches objectAtIndex:0] locationInView:[[theTouches objectAtIndex:0] view]];
	const CGPoint theEnd = [[theTouches objectAtIndex:1] locationInView:[[theTouches objectAtIndex:1] view]];
	const CGFloat theDistance = distance(theStart, theEnd);
	const CGPoint theCenter = CGPointMake((theStart.x + theEnd.x) / 2.0, (theStart.y + theEnd.y) / 2.0);

	
	[self pinchMoved:theDistance center:theCenter];
	}
}

- (void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
self.currentTouches = inTouches;
self.currentEvent = inEvent;

if (self.beginningTouchCount == 1)
	{
	if (self.isDrag == NO)
		{
		UITouch *theTouch = [inTouches anyObject];
		if (theTouch.tapCount == 1)
			[self tapped];
		else if (theTouch.tapCount == 2)
			[self doubleTapped];
		else
			[self multiTapped];
		}
	else
		[self dragEnded];
	}
else if (self.beginningTouchCount == 2)
	{
	[self pinchEnded];
	}

}

#pragma mark -

- (BOOL)dragWasFlick
{
UITouch *theTouch = self.currentTouches.anyObject;
const CGPoint theLocation = [theTouch locationInView:self.view];
const CGPoint theDelta = CGPointSubtract(theLocation, self.beginningLocation);
const CGFloat theMagnitude = magnitude(theDelta);
const CGFloat theSpeed = 1.0 / (self.currentEvent.timestamp - self.beginningTime) * theMagnitude;
return(theSpeed >= self.flickThreshold);
}

#pragma mark -

#pragma mark -

- (void)dragBegan
{
if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandlerDidReceiveDragBegan:)])
	[self.delegate eventHandlerDidReceiveDragBegan:self];
}

- (void)dragMoved
{
if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandlerDidReceiveDragMoved:)])
	[self.delegate eventHandlerDidReceiveDragMoved:self];

if ([self.delegate eventHandlerShouldScroll:self] == YES)
	{
	UITouch *theTouch = self.currentTouches.anyObject;
	const CGPoint theLocation = [theTouch locationInView:self.view];
	const CGPoint thePreviousLocation = [theTouch previousLocationInView:self.view];
	const CGPoint theDelta = { .x = -(theLocation.x - thePreviousLocation.x), .y = -(theLocation.y - thePreviousLocation.y) };
	[self scrollBy:theDelta];
	}
}

- (void)dragEnded
{
if ([self.delegate eventHandlerShouldScroll:self])
	{
	UITouch *theTouch = self.currentTouches.anyObject;
	const CGPoint theLocation = [theTouch locationInView:self.view];
	const CGPoint thePreviousLocation = [theTouch previousLocationInView:self.view];
	const CGPoint theDelta = { .x = -(theLocation.x - thePreviousLocation.x), .y = -(theLocation.y - thePreviousLocation.y) };
	[self scrollBy:theDelta];
	}

if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandlerDidReceiveDragEnded:)])
	[self.delegate eventHandlerDidReceiveDragEnded:self];
}

#pragma mark -

- (void)pinchBegan
{
}

- (void)pinchMoved:(CGFloat)inPinchDistance center:(CGPoint)inCenter
{
const CGFloat thePinchDelta = inPinchDistance - self.beginningPinchWidth;

[self zoomBy:thePinchDelta center:inCenter];

}

- (void)pinchEnded
{
}

#pragma mark -

- (void)tapped
{
if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandlerDidReceiveTap:)])
	[self.delegate eventHandlerDidReceiveTap:self];
}

- (void)doubleTapped
{
if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandlerDidReceiveDoubleTap:)])
	[self.delegate eventHandlerDidReceiveDoubleTap:self];
}

- (void)multiTapped
{
}

- (void)zoomBy:(CGFloat)inDelta center:(CGPoint)inCenter
{
if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandler:didReceiveZoomBy:center:)])
	[self.delegate eventHandler:self didReceiveZoomBy:inDelta center:inCenter];
}

- (void)scrollBy:(CGPoint)inDelta
{
if (self.delegate && [self.delegate respondsToSelector:@selector(eventHandler:didReceiveScrollBy:)])
	[self.delegate eventHandler:self didReceiveScrollBy:inDelta];
}

@end
