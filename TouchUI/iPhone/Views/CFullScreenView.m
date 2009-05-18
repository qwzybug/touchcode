//
//  CFullScreenView.m
//  PlateView
//
//  Created by Jonathan Wight on 1/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFullScreenView.h"

#import "UIView_Extensions.h"

@interface CFullScreenView ()
@property (readwrite, nonatomic, assign) NSTimer *autoHideTimer; // No need to be public
@end

#pragma mark -

@implementation CFullScreenView

@synthesize autoHideViews;
@synthesize autoHideStatusBar;
@synthesize autoHideTimer;
@synthesize autoHideDelay;

- (id)initWithCoder:(NSCoder *)inCoder
{
if (self = [super initWithCoder:inCoder])
	{
	[super setFrame:CGRectMake(0, -64, 320, 480)];
	self.autoHideStatusBar = YES;
	self.autoHideDelay = 5.0;
    }
return(self);
}

- (void)dealloc
{
self.autoHideViews = NULL;
//
[self.autoHideTimer invalidate];
self.autoHideTimer = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)willMoveToWindow:(UIWindow *)newWindow
{
//NSLog(@"* WILL MOVE TO WINDOW (%@)", newWindow);
[super willMoveToWindow:newWindow];

if (newWindow != NULL)
	{
	[self setClipsToBoundsRecursively:NO];
	}
else
	{
	//NSLog(@"SHOWING UI AGAIN");
	
	[self.autoHideTimer invalidate];
	self.autoHideTimer = NULL;
	//
	if (self.autoHideStatusBar)
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	//
	for (UIView *theView in self.autoHideViews)
		theView.alpha = 1.0;
	}
}

- (void)didMoveToWindow
{
//NSLog(@"* DID MOVE TO WINDOW (%@)", self.window);
[super didMoveToWindow];

[self setClipsToBoundsRecursively:NO];
if (self.window && self.autoHideTimer == NULL)
	{
	//NSLog(@"#### STARTING TIMER (A)");
	self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoHideDelay target:self selector:@selector(autoHideTimer:) userInfo:NULL repeats:NO];
	}
}

- (void)setFrame:(CGRect)inFrame
{
[super setFrame:CGRectMake(0, -64, 320, 480)];
}

- (void)showUI;
{
[self.autoHideTimer invalidate];
self.autoHideTimer = NULL;

if (self.autoHideStatusBar)
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];

if (self.autoHideViews != NULL)
	{
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.4];

	for (UIView *theView in self.autoHideViews)
		theView.alpha = 1.0;

	[UIView commitAnimations];
	}

if (self.autoHideTimer == NULL)
	{
	//NSLog(@"#### STARTING TIMER (B)");
	self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoHideDelay target:self selector:@selector(autoHideTimer:) userInfo:NULL repeats:NO];
	}
}

- (void)hideUI;
{
if (self.autoHideStatusBar)
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];

if (self.autoHideViews != NULL)
	{	
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.4];

	for (UIView *theView in self.autoHideViews)
		theView.alpha = 0.0;

	[UIView commitAnimations];
	}
}


- (void)autoHideTimer:(id)inParam
{
self.autoHideTimer = NULL;

[self hideUI];
}

@end
