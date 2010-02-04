//
//  CPopoverTestController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPopoverTestController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CMainController.h"
#import "CMenuSheet.h"

#import "CToolbarMenuViewController.h"

@implementation CPopoverTestController

- (void)viewDidAppear:(BOOL)inAnimated
{
[super viewDidAppear:inAnimated];

CMenu *theMenu = [CMainController instance].menu;


CToolbarMenuViewController *theContentController = [[[CToolbarMenuViewController alloc] initWithMenu:theMenu] autorelease];

UIPopoverController *thePopoverController = [[[UIPopoverController alloc] initWithContentViewController:theContentController] autorelease];
thePopoverController.popoverContentSize = theContentController.view.frame.size;




[thePopoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)self.tabBarItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];


}

@end
