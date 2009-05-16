//
//  CAScrollLayer_Extensions.m
//  Test
//
//  Created by Jonathan Wight on 04/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CAScrollLayer_Extensions.h"

@implementation CAScrollLayer (CAScrollLayer_Extensions)

- (void)scrollBy:(CGPoint)inDelta
{
const CGRect theVisibleRect = self.visibleRect;
const CGPoint theNewScrollLocation = { .x = CGRectGetMinX(theVisibleRect) + inDelta.x, .y = CGRectGetMinY(theVisibleRect) + inDelta.y };
[self scrollToPoint:theNewScrollLocation];
}

- (void)scrollCenterToPoint:(CGPoint)inPoint;
{
const CGRect theBounds = self.bounds;
const CGPoint theCenter = { 
	.x = CGRectGetMidX(theBounds),
	.y = CGRectGetMidY(theBounds),
	};
const CGPoint theNewPoint = {
	.x = inPoint.x - theCenter.x,
	.y = inPoint.y - theCenter.y,
	};

[self scrollToPoint:theNewPoint];
}

@end
