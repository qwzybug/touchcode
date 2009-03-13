//
//  CBorderView.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CBorderView.h"

@implementation CBorderView

@synthesize frameInset;
@synthesize cornerRadius;
@synthesize frameWidth;
@synthesize frameColor;
@synthesize fillColor;

- (id)initWithFrame:(CGRect)frame
{
if (self = [super initWithFrame:frame])
	{
	[self setup];
    }
return self;
}

- (id)initWithCoder:(NSCoder *)inCoder
{
if (self = [super initWithCoder:inCoder])
	{
	[self setup];
    }
return self;
}

- (void)dealloc
{
self.frameColor = NULL;
self.fillColor = NULL;
//
[super dealloc];
}

- (void)drawRect:(CGRect)rect
{
CGContextRef theContext = UIGraphicsGetCurrentContext();

const CGFloat R = self.cornerRadius;

const CGRect theBounds = CGRectInset(self.bounds, self.frameInset, self.frameInset);
const CGFloat theMinX = CGRectGetMinX(theBounds);
const CGFloat theMaxX = CGRectGetMaxX(theBounds);
const CGFloat theMinY = CGRectGetMinY(theBounds);
const CGFloat theMaxY = CGRectGetMaxY(theBounds);


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

CGContextSetLineWidth(theContext, self.frameWidth);

CGContextSetStrokeColorWithColor(theContext, self.frameColor.CGColor);
CGContextSetFillColorWithColor(theContext, self.fillColor.CGColor);

CGContextDrawPath(theContext, kCGPathFillStroke);
}

- (void)setup
{
self.backgroundColor = [UIColor clearColor];
//
self.frameInset = 1.5;
self.cornerRadius = 10.0;
self.frameWidth = 1.5;
self.frameColor = [UIColor lightGrayColor];
self.fillColor = [UIColor whiteColor];
}

- (CGSize)sizeThatFits:(CGSize)size
{
if (self.subviews.count == 0)
	{
	return(self.frame.size);
	}
else
	{
	CGRect theContentsFrame = CGRectZero;
	for (UIView *theView in self.subviews)
		{
		theContentsFrame = CGRectUnion(theContentsFrame, theView.frame);
		}
	theContentsFrame = CGRectInset(theContentsFrame, - 5, - 5);

	theContentsFrame.size.width = MAX(theContentsFrame.size.width, self.cornerRadius + self.frameInset * 2);
	theContentsFrame.size.height = MAX(theContentsFrame.size.height, self.cornerRadius + self.frameInset * 2);

	theContentsFrame.size.width = MIN(theContentsFrame.size.width, size.width);

	return(theContentsFrame.size);
	}
}

@end
