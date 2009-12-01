//
//  QuartzUtilities.m
//  KytePhase2
//
//  Created by Jonathan Wight on 04/18/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "QuartzUtilities.h"

void CGContextAddHorizontalLine(CGContextRef inContext, CGFloat X)
{
CGPoint theCurrentPoint = CGContextGetPathCurrentPoint(inContext);
CGContextAddLineToPoint(inContext, theCurrentPoint.x + X, theCurrentPoint.y);
}

void CGContextAddVerticalLine(CGContextRef inContext, CGFloat Y)
{
CGPoint theCurrentPoint = CGContextGetPathCurrentPoint(inContext);
CGContextAddLineToPoint(inContext, theCurrentPoint.x, theCurrentPoint.y + Y);
}

void CGContextAddRelativeLine(CGContextRef inContext, CGFloat X, CGFloat Y)
{
CGPoint theCurrentPoint = CGContextGetPathCurrentPoint(inContext);
CGContextAddLineToPoint(inContext, theCurrentPoint.x + X, theCurrentPoint.y + Y);
}

void CGContextAddRoundRectToPath(CGContextRef inContext, CGRect inBounds, CGFloat inTopLeftRadius, CGFloat inTopRightRadius, CGFloat inBottomLeftRadius, CGFloat inBottomRightRadius)
{
const CGFloat theMinX = CGRectGetMinX(inBounds);
const CGFloat theMaxX = CGRectGetMaxX(inBounds);
const CGFloat theMinY = CGRectGetMinY(inBounds);
const CGFloat theMaxY = CGRectGetMaxY(inBounds);

const CGFloat theTopLength = CGRectGetWidth(inBounds) - inTopLeftRadius - inTopRightRadius;
const CGFloat theLeftHeight = CGRectGetHeight(inBounds) - inTopLeftRadius - inBottomLeftRadius;
const CGFloat theBottomLength = CGRectGetWidth(inBounds) - inBottomLeftRadius - inBottomRightRadius;
const CGFloat theRightHeight = CGRectGetHeight(inBounds) - inTopRightRadius - inBottomRightRadius;

// TOP LEFT
CGContextMoveToPoint(inContext, theMinX + inTopLeftRadius, theMinY);

// DRAW TO TOP RIGHT
CGContextAddHorizontalLine(inContext, theTopLength);
CGContextAddCurveToPoint(inContext, theMaxX, theMinY, theMaxX, theMinY + inTopRightRadius, theMaxX, theMinY + inTopRightRadius);

// DRAW TO BOTTOM RIGHT
CGContextAddVerticalLine(inContext, theRightHeight);
CGContextAddCurveToPoint(inContext, theMaxX, theMaxY, theMaxX - inBottomRightRadius, theMaxY, theMaxX - inBottomRightRadius, theMaxY);

// DRAW TO BOTTOM LEFT
CGContextAddHorizontalLine(inContext, -theBottomLength);
CGContextAddCurveToPoint(inContext, theMinX, theMaxY, theMinX, theMaxY - inBottomLeftRadius, theMinX, theMaxY - inBottomLeftRadius);

// DRAW TO TOP LEFT
CGContextAddVerticalLine(inContext, -theLeftHeight);
CGContextAddCurveToPoint(inContext, theMinX, theMinY, theMinX + inTopLeftRadius, theMinY, theMinX + inTopLeftRadius, theMinY);
}

