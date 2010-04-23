//
//  UIWindow_TestExtensions.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/9/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIWindow_TestExtensions.h"

#import "UIView_TestExtensions.h"

@implementation UIWindow (UIWindow_TestExtensions)

- (UIView *)mainView
{
UIView *theMainView = NULL;

#if defined(__IPHONE_4_0)
//__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0)
theMainView = self.rootViewController.view;
#else
#warning Private API usage ahoy!
UIView *theWrapperView = [self findDeepViewOfClass:NSClassFromString(@"UIViewControllerWrapperView")];
NSAssert(theWrapperView != NULL, @"Could not find view of class.");
theMainView = [theWrapperView.subviews lastObject];
#endif

NSAssert(theMainView != NULL, @"Could not find mainView");
return(theMainView);
}

@end
