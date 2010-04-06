//
//  UIView_AnimationExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/9/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIView_AnimationExtensions.h"

@implementation UIView (UIView_AnimationExtensions)

- (void)addSubview:(UIView *)inSubview withAnimationType:(EViewAnimationType)inAnimationType
{
if (inAnimationType == ViewAnimationType_SlideDown
	|| inAnimationType == ViewAnimationType_SlideUp
	|| inAnimationType == ViewAnimationType_SlideLeft
	|| inAnimationType == ViewAnimationType_SlideRight)
	{
	CGRect theFrame = inSubview.frame;

	UIView *theMaskView = [[[UIView alloc] initWithFrame:theFrame] autorelease];
	//theMaskView.backgroundColor = [UIColor greenColor];
	theMaskView.opaque = NO;
	theMaskView.clipsToBounds = YES;

	theFrame.origin = CGPointZero;

	switch (inAnimationType)
		{
		case ViewAnimationType_SlideDown:
			theFrame.origin.y -= theFrame.size.height;
			break;
		case ViewAnimationType_SlideUp:
			theFrame.origin.y += theFrame.size.height;
			break;
		case ViewAnimationType_SlideLeft:
			theFrame.origin.x += theFrame.size.width;
			break;
		case ViewAnimationType_SlideRight:
			theFrame.origin.x -= theFrame.size.width;
			break;
		}

	inSubview.frame = theFrame;

	[theMaskView addSubview:inSubview];

	[self addSubview:theMaskView];

	[UIView beginAnimations:@"TODO_ADD" context:inSubview];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationDelegate:self];

	inSubview.frame = theMaskView.bounds;

	[UIView commitAnimations];
	}
else if (inAnimationType == ViewAnimationType_FadeIn)
	{
	inSubview.alpha = 0.0f;
	[self addSubview:inSubview];

	[UIView beginAnimations:@"TODO_FADE_IN" context:inSubview];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationDelegate:self];

	inSubview.alpha = 1.0f;

	[UIView commitAnimations];
	}
}

- (void)removeFromSuperviewWithAnimationType:(EViewAnimationType)inAnimationType
{
if (inAnimationType == ViewAnimationType_SlideDown
	|| inAnimationType == ViewAnimationType_SlideUp
	|| inAnimationType == ViewAnimationType_SlideLeft
	|| inAnimationType == ViewAnimationType_SlideRight)
	{
	CGRect theFrame = self.frame;
	UIView *theSuperView = self.superview;
	UIView *theMaskView = [[[UIView alloc] initWithFrame:theFrame] autorelease];
	[theSuperView addSubview:theMaskView];
	[self retain];
	[self removeFromSuperview];
	theFrame.origin = CGPointZero;
	self.frame = theFrame;

	[theMaskView addSubview:self];
	[self release];

	[UIView beginAnimations:@"TODO_REMOVE" context:self];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];

	theFrame.origin = CGPointZero;

	switch (inAnimationType)
		{
		case ViewAnimationType_SlideDown:
			theFrame.origin.y += theFrame.size.height;
			break;
		case ViewAnimationType_SlideUp:
			theFrame.origin.y -= theFrame.size.height;
			break;
		case ViewAnimationType_SlideLeft:
			theFrame.origin.x -= theFrame.size.width;
			break;
		case ViewAnimationType_SlideRight:
			theFrame.origin.x += theFrame.size.width;
			break;
		}

	self.frame = theFrame;

	[UIView commitAnimations];
	}
else if (inAnimationType == ViewAnimationType_FadeOut)
	{
	[UIView beginAnimations:@"TODO_FADE_OUT" context:self];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];

	self.alpha = 0.0f;

	[UIView commitAnimations];
	}
}

#pragma mark -

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
if ([animationID isEqualToString:@"TODO_ADD"])
	{
	UIView *theSubview = context;

	[theSubview retain];

	UIView *theMaskView = theSubview.superview;
	theSubview.frame = theMaskView.frame;
	[theSubview removeFromSuperview];
	[self addSubview:theSubview];
	[theMaskView removeFromSuperview];

	[theSubview release];
	}
else if ([animationID isEqualToString:@"TODO_REMOVE"])
	{
	UIView *theSubview = context;

	UIView *theMaskView = theSubview.superview;
	[theMaskView removeFromSuperview];
	}
else if ([animationID isEqualToString:@"TODO_FADE_OUT"])
	{
	UIView *theSubview = context;
	[theSubview removeFromSuperview];
	}
}

@end
