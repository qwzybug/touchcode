//
//  CHUDView.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CHUDView.h"

#import "QuartzUtilities.h"

@implementation CHUDView

@synthesize borderWidth;
@dynamic contentView;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.contentMode = UIViewContentModeRedraw;
	//
	borderWidth = 10.0f;
	}
return(self);
}

- (UIView *)contentView
{
NSAssert(self.subviews.count <= 1, @"TODO");
return([self.subviews lastObject]);
}

- (void)setContentView:(UIView *)inContentView
{
NSAssert(self.subviews.count <= 1, @"TODO");
if (self.subviews.count == 1)
	{
	UIView *theCurrentView = [self.subviews lastObject];
	[theCurrentView removeFromSuperview];
	}

if (inContentView)
	{
	CGRect theFrame = self.bounds;
	theFrame = CGRectInset(theFrame, self.borderWidth, self.borderWidth);
	inContentView.frame = theFrame;
	[self addSubview:inContentView];
	}
}

- (void)drawRect:(CGRect)inRect
{
CGRect theRect = self.bounds;

CGContextRef theContext = UIGraphicsGetCurrentContext();

[[UIColor colorWithWhite:0.0f alpha:0.75f] set];

CGContextAddRoundRectToPath(theContext, theRect, self.borderWidth, self.borderWidth, self.borderWidth, self.borderWidth);
CGContextFillPath(theContext);
}

@end
