//
//  CBubbleUserNotificationStyle.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CBubbleUserNotificationStyle.h"

#import "CUserNotification.h"
#import "CBubbleView.h"
#import "UIView_AnimationExtensions.h"
#import "CUserNotificationManager.h"

@implementation CBubbleUserNotificationStyle

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
[[CUserNotificationManager instance] registerStyleName:@"BUBBLE-TOP" class:self options:NULL];
[thePool release];
}

- (void)showNotification:(CUserNotification *)inNotification
{
UIView *theMainView = self.manager.mainView;

CBubbleView *theBubbleView = [[[CBubbleView alloc] initWithFrame:CGRectMake(0, 0, theMainView.bounds.size.width, 44)] autorelease];
theBubbleView.titleLabel.text = inNotification.title;
theBubbleView.messageLabel.text = inNotification.message;
//UIView *theAccessoryView = NULL;
//if (inNotification.progress >= 0.0 && inNotification.progress <= 1.0)
//	{
//	UIProgressView *theProgressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
//	theProgressView.progress = inNotification.progress;
//	theProgressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//
//	UIView *theCenteringView = [[[UIView alloc] initWithFrame:CGRectInset(theProgressView.bounds, -10, -10)] autorelease];
//	[theCenteringView addSubview:theProgressView];
//
//	theAccessoryView = theCenteringView;
//	}
//else if (isinf(inNotification.progress))
//	{
//	UIActivityIndicatorView *theActivityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
//	theActivityView.hidesWhenStopped = NO;
//	theActivityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//	[theActivityView startAnimating];
//
//	UIView *theCenteringView = [[[UIView alloc] initWithFrame:CGRectInset(theActivityView.bounds, -10, -10)] autorelease];
//	[theCenteringView addSubview:theActivityView];
//
//	theAccessoryView = theCenteringView;
//	}
////if (theAccessoryView)
////	theBubbleView.accessoryViews = [NSArray arrayWithObject:theAccessoryView];

self.view = theBubbleView;

[theMainView addSubview:view withAnimationType:ViewAnimationType_SlideDown];
}

- (void)hideNotification:(CUserNotification *)inNotification
{
[self.view removeFromSuperviewWithAnimationType:ViewAnimationType_SlideUp];
}


@end
