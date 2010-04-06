//
//  CCenteringView.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/18/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CCenteringView.h"

#import "Geometry.h"

@implementation CCenteringView

- (id)initWithView:(UIView *)inView
{
if ((self = [super initWithFrame:inView.frame]) != NULL)
	{
	self.autoresizesSubviews = NO;

	CGRect theFrame = { CGPointZero, inView.frame.size };


	inView.frame = theFrame;

	[self addSubview:inView];

	}
return(self);
}

- (void)layoutSubviews
{
UIView *theView = [self.subviews lastObject];
theView.frame = ScaleAndAlignRectToRect(theView.bounds, self.bounds, ImageScaling_None, ImageAlignment_Center);
}

@end
