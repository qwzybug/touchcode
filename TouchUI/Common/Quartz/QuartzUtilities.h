//
//  QuartzUtilities.h
//  KytePhase2
//
//  Created by Jonathan Wight on 04/18/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

extern void CGContextAddHorizontalLine(CGContextRef inContext, CGFloat X);
extern void CGContextAddVerticalLine(CGContextRef inContext, CGFloat Y);
extern void CGContextAddRelativeLine(CGContextRef inContext, CGFloat X, CGFloat Y);
extern void CGContextAddRoundRectToPath(CGContextRef inContext, CGRect inBounds, CGFloat inTopLeftRadius, CGFloat inTopRightRadius, CGFloat inBottomLeftRadius, CGFloat inBottomRightRadius);
