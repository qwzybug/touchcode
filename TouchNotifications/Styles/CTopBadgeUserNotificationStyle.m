//
//  CTopBadgeUserNotificationStyle.m
//  UserNotificationManager
//
//  Created by Mike Pattee on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CTopBadgeUserNotificationStyle.h"

#import "Geometry.h"
#import "CTopBadgeView.h"
#import "CUserNotificationManager.h"
#import "CUserNotification.h"
#import "UIView_AnimationExtensions.h"
#import "UIView_LayoutExtensions.h"

@interface CTopBadgeUserNotificationStyle ()
- (CTopBadgeView *)newBadgeView;
@end

#pragma mark -

@implementation CTopBadgeUserNotificationStyle

- (NSUInteger)flags
{
	return(UserNotificationStyleFlag_ReuseStyle);
}

- (void)showNotification:(CUserNotification *)inNotification
{
	UIView *theMainView = self.manager.mainView;
	
	//UIActivityIndicatorView *theActivityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	//[theActivityIndicator startAnimating];
	
	CTopBadgeView *theBadgeView = NULL;
	if (self.view)
	{
		theBadgeView = (CTopBadgeView *)self.view;
	}
	else
	{
		theBadgeView = [[self newBadgeView] autorelease];
	}
	
	theBadgeView.imageView.image = inNotification.icon;
	theBadgeView.titleLabel.text = inNotification.title;
	[theBadgeView.titleLabel sizeToFit:CGSizeMake(INFINITY, INFINITY)];
	
	//theBadgeView.accessoryView = theActivityIndicator;
	
	if (self.view == NULL)
	{
		[theBadgeView layoutSubviews];
		[theBadgeView sizeToFit];
		theBadgeView.frame = ScaleAndAlignRectToRect(theBadgeView.frame, theMainView.bounds, ImageScaling_None, ImageAlignment_TopLeft);
		
		self.view = theBadgeView;
		
		[theMainView addSubview:self.view withAnimationType:ViewAnimationType_SlideRight];
	}
	else
	{
		[UIView beginAnimations:@"TODO_MOVE" context:NULL];
		
		CGRect theFrame = { .origin = theBadgeView.frame.origin, .size = { theBadgeView.superview.bounds.size.width - 20, theBadgeView.frame.size.height } };
		theFrame.size = [theBadgeView sizeThatFits:theFrame.size];
		theBadgeView.frame = ScaleAndAlignRectToRect(theFrame, theMainView.bounds, ImageScaling_None, ImageAlignment_TopLeft);
		
		[UIView commitAnimations];
	}
}

- (void)hideNotification:(CUserNotification *)inNotification
{
	[self.view removeFromSuperviewWithAnimationType:ViewAnimationType_SlideLeft];
}

- (CTopBadgeView *)newBadgeView
{
	CTopBadgeView *theBadgeView = [[CTopBadgeView alloc] initWithFrame:CGRectMake(0, 0, 300, 28)];
	[theBadgeView addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
	theBadgeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	return(theBadgeView);
}

@end
