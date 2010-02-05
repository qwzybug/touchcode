//
//  CPopoverTestController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPopoverToolbarTestController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CMainController.h"
#import "CMenuSheet.h"

#import "CToolbarMenuViewController.h"
#import "CBlankViewController.h"
#import "CHostingView.h"

@implementation CPopoverToolbarTestController

@synthesize toolbarMenuController;

- (void)viewDidAppear:(BOOL)inAnimated
{
[super viewDidAppear:inAnimated];

CMenu *theMenu = [CMainController instance].menu;


self.toolbarMenuController = [[[CToolbarMenuViewController alloc] initWithMenu:theMenu] autorelease];
self.toolbarMenuController.delegate = self;

UIPopoverController *thePopoverController = [[[UIPopoverController alloc] initWithContentViewController:self.toolbarMenuController] autorelease];
thePopoverController.popoverContentSize = self.toolbarMenuController.view.frame.size;

[thePopoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)self.tabBarItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

[self.toolbarMenuController selectMenuItem:[theMenu.items objectAtIndex:0]];
}

- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectMenuItem:(CMenuItem *)inMenuItem;
{
if (inMenuItem.submenu != NULL)
	return(NO);
	
CBlankViewController *theBlankViewController = [[[CBlankViewController alloc] initWithText:inMenuItem.title] autorelease];
theBlankViewController.title = inMenuItem.title;


self.toolbarMenuController.contentView.viewController = theBlankViewController;

NSLog(@"FOO");
return(YES);
}


@end
