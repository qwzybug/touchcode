//
//  CWindowViewFlipper.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/30/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CWindowViewFlipper.h"

@implementation CWindowViewFlipper

@synthesize viewOne;
@synthesize viewTwo;
@synthesize transition;
@synthesize animationDuration;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.transition = UIViewAnimationTransitionFlipFromLeft;
	self.animationDuration = 0.5;
	}
return(self);
}

- (void)dealloc
{
self.viewOne = NULL;
self.viewTwo = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)flipView:(UIView *)inViewOne toView:(UIView *)inViewTwo
{
self.viewOne = inViewOne;
self.viewTwo = inViewTwo;

[self flip];
}

- (void)flip
{
UIView *theSuperView = self.viewOne.superview;

[UIView beginAnimations:NULL context:NULL];
[UIView setAnimationDuration:animationDuration];
[UIView setAnimationTransition:self.transition forView:theSuperView cache:YES];

[self.viewOne removeFromSuperview];
[theSuperView addSubview:self.viewTwo];

[UIView commitAnimations];

UIView *theTemp = self.viewOne;
self.viewOne = self.viewTwo;
self.viewTwo = theTemp;

self.transition = (self.transition == UIViewAnimationTransitionFlipFromLeft ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft);
}

@end
