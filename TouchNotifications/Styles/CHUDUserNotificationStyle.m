//
//  CHUDUserNotificationStyle.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CHUDUserNotificationStyle.h"

#import "CBubbleView.h"
#import "UIView_AnimationExtensions.h"
#import "CHUDView.h"
#import "CUserNotificationManager.h"
#import "CUserNotification.h"
#import "Geometry.h"
#import "CCenteringView.h"
#import "UIView_LayoutExtensions.h"

#define NO_ANIMATION 1

NSString *kHUDNotificationFullScreenKey = @"kHUDNotificationFullScreenKey";
NSString *kHUDNotificationDontUseMaskingViewKey = @"kHUDNotificationDontUseMaskingViewKey";

@interface CHUDUserNotificationStyle ()
@property (readwrite, nonatomic, retain) UIView *maskingView;
@end

#pragma mark -

@implementation CHUDUserNotificationStyle

@synthesize maskingView;

- (void)showNotification:(CUserNotification *)inNotification
{
//NSLog(@"SHOW NOTIFICATION: %@", inNotification);

const BOOL theFullScreenFlag = [[self.styleOptions objectForKey:kHUDNotificationFullScreenKey] boolValue];
const BOOL theDontUseMaskingViewFlag = [[self.styleOptions objectForKey:kHUDNotificationDontUseMaskingViewKey] boolValue];

UIView *theMainView = self.manager.mainView;

CGRect theFrame;
CGFloat theBorderWidth;
UIViewAutoresizing theAutoresizingFlag;

if (theFullScreenFlag == YES)
	{
	theFrame = theMainView.bounds;
	theBorderWidth = 0.0;
	theAutoresizingFlag = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
else
	{
	theFrame = CGRectMake(0, 0, 240, 240);

	theFrame = ScaleAndAlignRectToRect(theFrame, theMainView.bounds, ImageScaling_None, ImageAlignment_Center);

	theBorderWidth = 10.0;
	theAutoresizingFlag = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	}

CHUDView *theHUDView = [[[CHUDView alloc] initWithFrame:theFrame] autorelease];
theHUDView.borderWidth = theBorderWidth;
theHUDView.autoresizingMask = theAutoresizingFlag;

CBubbleView *theBubbleView = [[[CBubbleView alloc] initWithFrame:theMainView.frame] autorelease];
theBubbleView.titleLabel.text = inNotification.title;
theBubbleView.messageLabel.text = inNotification.message;
theBubbleView.messageLabel.lineBreakMode = UILineBreakModeWordWrap;
theBubbleView.messageLabel.numberOfLines = 0;
[theBubbleView.messageLabel sizeToFit:CGSizeMake(200, 10000)];

UIView *theAccessoryView = NULL;
if (inNotification.progress >= 0.0 && inNotification.progress <= 1.0)
	{
	UIProgressView *theProgressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
	theProgressView.progress = inNotification.progress;
	theProgressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

	CCenteringView *theCenteringView = [[[CCenteringView alloc] initWithView:theProgressView] autorelease];

	theAccessoryView = theCenteringView;
	}
else if (isinf(inNotification.progress))
	{
	UIActivityIndicatorView *theActivityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	theActivityView.hidesWhenStopped = NO;
	theActivityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[theActivityView startAnimating];

	CCenteringView *theCenteringView = [[[CCenteringView alloc] initWithView:theActivityView] autorelease];

	theAccessoryView = theCenteringView;
	}
if (theAccessoryView)
	theBubbleView.accessoryViews = [NSArray arrayWithObject:theAccessoryView];

theBubbleView.opaque = NO;
theBubbleView.backgroundColor = [UIColor clearColor];
theBubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

theHUDView.contentView = theBubbleView;

self.view = theHUDView;

if (theFullScreenFlag == YES)
	{
	#if NO_ANIMATION == 1
	[theMainView addSubview:self.view];
	#else
	[theMainView addSubview:self.view withAnimationType:ViewAnimationType_FadeIn];
	#endif
	}
else if (theDontUseMaskingViewFlag == NO)
	{
	self.maskingView = [[[UIView alloc] initWithFrame:theMainView.bounds] autorelease];
	self.maskingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[theMainView addSubview:self.maskingView];

	#if NO_ANIMATION == 1
	[self.maskingView addSubview:self.view];
	#else
	[self.maskingView addSubview:self.view withAnimationType:ViewAnimationType_FadeIn];
	#endif
	}
}

- (void)hideNotification:(CUserNotification *)inNotification
{
//[self.view removeFromSuperwiewWithAnimationType:ViewAnimationType_FadeOut];

#if NO_ANIMATION == 1
[self.view removeFromSuperview];
#else
[UIView beginAnimations:@"TODO_FADE_OUT" context:self];
[UIView setAnimationDuration:0.4];
[UIView setAnimationDelegate:self];

self.view.alpha = 0.0;

[UIView commitAnimations];
#endif
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
[self.view removeFromSuperview];
[self.maskingView removeFromSuperview];
self.maskingView = NULL;
}

@end
