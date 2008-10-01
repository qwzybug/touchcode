//
//  CALayer_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/24/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CALayer_Extensions.h"

@implementation CALayer (CALayer_Extensions)

- (id)initWithFrame:(CGRect)inFrame
{
if ((self = [self init]) != NULL)
	{
	self.frame = inFrame;
	}
return(self);
}

#pragma mark -

@dynamic name;

#pragma mark -

@dynamic zoom;

- (CGFloat)zoom
{
const CATransform3D theTransform = self.transform;
if (theTransform.m11 == theTransform.m22 == theTransform.m33)
	{
	return(theTransform.m11);
	}
else
	{
	return((theTransform.m11 + theTransform.m22 + theTransform.m33) / 3.0);
	}
}

- (void)setZoom:(CGFloat)inZoom
{
CATransform3D theTransform = self.transform;
theTransform.m11 = theTransform.m22 = theTransform.m33 = inZoom;
self.transform = theTransform;
}

- (void)setZoom:(CGFloat)inZoom centeringAtPoint:(CGPoint)inPoint
{
CATransform3D theTransform = self.transform;

theTransform = CATransform3DTranslate(theTransform, inPoint.x, inPoint.y, 0.0);

theTransform.m11 = theTransform.m22 = theTransform.m33 = inZoom;

theTransform = CATransform3DTranslate(theTransform, -inPoint.x, -inPoint.y, 0.0);

self.transform = theTransform;
}

- (CAScrollLayer *)scrollLayer
{
CALayer *theLayer = self.superlayer;
while (theLayer && [theLayer isKindOfClass:[CAScrollLayer class]] == NO)
	{
	theLayer = theLayer.superlayer;
	}
return((CAScrollLayer *)theLayer);
}

@end
