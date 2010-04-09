//
//  UIViewController_Extensions.m
//  touchcode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "UIViewController_Extensions.h"

@implementation UIViewController (UIViewController_Extensions)

@dynamic isModal;

- (BOOL)isModal
{
return(self.navigationController.parentViewController.modalViewController == self.navigationController);
}

- (void)dismissAnimated:(BOOL)inAnimated;
{
if (self.isModal)
	[self dismissModalViewControllerAnimated:YES];
else
	[self.navigationController popViewControllerAnimated:YES];
}

@end
