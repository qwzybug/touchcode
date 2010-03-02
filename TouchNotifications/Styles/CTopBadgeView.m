//
//  CTopBadgeView.m
//  UserNotificationManager
//
//  Created by Mike Pattee on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CTopBadgeView.h"

#import "QuartzUtilities.h"
#import "CLayoutView.h"

@implementation CTopBadgeView

- (void)drawRect:(CGRect)inRect
{
	CGRect theRect = self.bounds;
	
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	
	[[UIColor colorWithWhite:0.0f alpha:0.6f] set];
	
	CGContextAddRoundRectToPath(theContext, theRect, 0, 0, 0, 20);
	CGContextFillPath(theContext);
	
#if DEBUG_RECT == 1
	[[UIColor redColor] set];
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.bounds);
	[[UIColor orangeColor] set];
	for (UIView *theView in self.subviews)
	{
		CGRect theFrame = theView.frame;
		CGContextStrokeRect(UIGraphicsGetCurrentContext(), theFrame);
	}
#endif /* DEBUG_RECT == 1 */
}

@end
