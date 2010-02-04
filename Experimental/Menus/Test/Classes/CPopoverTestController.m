    //
//  CPopoverTestController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPopoverTestController.h"

#import "CMenuTableViewController.h"
#import "CMainController.h"

@implementation CPopoverTestController

@synthesize popoverController;

- (void)viewDidAppear:(BOOL)inAnimated
{
[super viewDidAppear:inAnimated];

CMenu *theMenu = [CMainController instance].menu;

CMenuTableViewController *theMenuTableViewController = [[[CMenuTableViewController alloc] initWithMenu:theMenu] autorelease];
theMenuTableViewController.hidesNavigationBar = YES;



UINavigationController *theNavigationController = [[[UINavigationController alloc] initWithRootViewController:theMenuTableViewController] autorelease];
theNavigationController.navigationBarHidden = YES;
theNavigationController.view.frame = CGRectMake(0, 0, 320, 320);


self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:theNavigationController] autorelease];
self.popoverController.popoverContentSize = CGSizeMake(320, 320);

[self.popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)self.tabBarItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectMenuItem:(CMenuItem *)inMenuItem;
//{
//if (inMenuItem.submenu != NULL)
//	return(NO);
//	
//CBlankViewController *theBlankViewController = [[[CBlankViewController alloc] initWithText:inMenuItem.title] autorelease];
//theBlankViewController.title = inMenuItem.title;
//
//
//self.toolbarMenuController.contentView.viewController = theBlankViewController;
//
//NSLog(@"FOO");
//return(YES);
//}


@end
