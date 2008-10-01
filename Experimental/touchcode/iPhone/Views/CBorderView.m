//
//  CBorderView.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CBorderView.h"


@implementation CBorderView

- (id)initWithFrame:(CGRect)frame
{
if (self = [super initWithFrame:frame])
	{
	self.backgroundColor = [UIColor clearColor];
    }
return self;
}

- (id)initWithCoder:(NSCoder *)inCoder
{
if (self = [super initWithCoder:inCoder])
	{
	self.backgroundColor = [UIColor clearColor];
    }
return self;
}

- (void)dealloc
{
self.backgroundColor = NULL;
//
[super dealloc];
}

- (void)drawRect:(CGRect)rect
{
const CGFloat R = 10.0;

const CGRect theBounds = self.bounds;
const CGFloat theMinX = CGRectGetMinX(theBounds);
const CGFloat theMaxX = CGRectGetMaxX(theBounds);
const CGFloat theMinY = CGRectGetMinY(theBounds);
const CGFloat theMaxY = CGRectGetMaxY(theBounds);

CGContextRef theContext = UIGraphicsGetCurrentContext();

CGContextBeginPath(theContext);
CGContextMoveToPoint(theContext, theMinX + R, theMinY);

CGContextAddLineToPoint(theContext, theMaxX - R, theMinY);
CGContextAddCurveToPoint(theContext, theMaxX, theMinY, theMaxX, theMinY + R, theMaxX, theMinY + R);

CGContextAddLineToPoint(theContext, theMaxX, theMaxY - R);
CGContextAddCurveToPoint(theContext, theMaxX, theMaxY, theMaxX - R, theMaxY, theMaxX - R, theMaxY);

CGContextAddLineToPoint(theContext, theMinX + R, theMaxY);
CGContextAddCurveToPoint(theContext, theMinX, theMaxY, theMinX, theMaxY - R, theMinX, theMaxY - R);

CGContextAddLineToPoint(theContext, theMinX, theMinY + R);
CGContextAddCurveToPoint(theContext, theMinX, theMinY, theMinX + R, theMinY, theMinX + R, theMinY);

CGContextClosePath(theContext);

CGContextSetStrokeColorWithColor(theContext, [UIColor lightGrayColor].CGColor);
CGContextSetFillColorWithColor(theContext, [UIColor whiteColor].CGColor);

CGContextDrawPath(theContext, kCGPathFillStroke);
}

@end
