//
//  UIView_TestExtensions.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/9/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIView_TestExtensions.h"

@implementation UIView (UIView_TestExtensions)

- (UIView *)findDeepViewOfClass:(Class)inClass
{
if ([self isKindOfClass:inClass])
	return(self);
for (UIView *theView in self.subviews)
	{
	theView = [theView findDeepViewOfClass:inClass];
	if (theView)
		return(theView);
	}
return(NULL);
}

@end
