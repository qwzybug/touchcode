//
//  CHostingView.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CHostingView.h"


@implementation CHostingView

@synthesize viewController;

- (void)setViewController:(UIViewController *)inViewController
{
if (viewController != inViewController)
	{
	if (viewController)
		{
		[viewController viewWillDisappear:NO];
		[viewController.view removeFromSuperview];
		[viewController viewDidDisappear:NO];
		
		[viewController release];
		viewController = NULL;
		}
	
	if (inViewController)
		{
		viewController = [inViewController retain];
		
		viewController.view.frame = self.bounds;
		viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		[viewController viewWillAppear:NO];
		[self addSubview:viewController.view];
		[viewController viewDidAppear:NO];
		}
	}
}

@end
