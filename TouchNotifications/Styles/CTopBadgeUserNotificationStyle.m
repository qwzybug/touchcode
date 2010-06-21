//
//  CTopBadgeUserNotificationStyle.m
//  TouchCode
//
//  Created by Mike Pattee on 3/1/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CTopBadgeUserNotificationStyle.h"

#import "Geometry.h"
#import "CBadgeView.h"
#import "CUserNotificationManager.h"
#import "CUserNotification.h"
#import "UIView_AnimationExtensions.h"
#import "UIView_LayoutExtensions.h"

@interface CTopBadgeUserNotificationStyle ()
- (CBadgeView *)newBadgeView;
@end

#pragma mark -

@implementation CTopBadgeUserNotificationStyle

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
[[CUserNotificationManager instance] registerStyleName:@"BADGE-TOP-LEFT" class:self options:NULL];
[thePool release];
}

- (NSUInteger)flags
{
return(UserNotificationStyleFlag_ReuseStyle);
}

- (void)showNotification:(CUserNotification *)inNotification
{
UIView *theMainView = self.manager.mainView;

UIActivityIndicatorView *theActivityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
[theActivityIndicator startAnimating];

CBadgeView *theBadgeView = NULL;
if (self.view)
	{
	theBadgeView = (CBadgeView *)self.view;
	}
else
	{
	theBadgeView = [[self newBadgeView] autorelease];
	}

theBadgeView.imageView.image = inNotification.icon;
theBadgeView.titleLabel.text = inNotification.title;
[theBadgeView.titleLabel sizeToFit:CGSizeMake(INFINITY, INFINITY)];

theBadgeView.accessoryView = theActivityIndicator;

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

- (CBadgeView *)newBadgeView
{
CBadgeView *theBadgeView = [[CBadgeView alloc] initWithFrame:CGRectMake(0, 0, 300, 28)];
theBadgeView.badgePosition = BadgePositionTopLeft;
[theBadgeView addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
theBadgeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
return(theBadgeView);
}

@end
