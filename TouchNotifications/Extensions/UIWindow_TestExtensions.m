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
#warning Private API usage ahoy!

UIView *theWrapperView = [self findDeepViewOfClass:NSClassFromString(@"UIViewControllerWrapperView")];
UIView *theView = [theWrapperView.subviews lastObject];
return(theView);
}

@end
