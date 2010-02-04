    //
//  CMenuTesterViewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuTesterViewController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CMainController.h"

@implementation CMenuTesterViewController

@synthesize currentPopoverController;

- (void)dealloc
{
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.menu = [CMainController instance].menu;
self.title = @"Menu";
self.hidesNavigationBar = YES;
self.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(YES);
}

- (IBAction)actionPopover:(id)inSender
{
NSLog(@"Pop Over: %@", inSender);

CMenuTableViewController *theCurrentMenuTableViewController = [inSender UIElement];
NSIndexPath *theIndexPath = [theCurrentMenuTableViewController indexPathForMenuItem:inSender];
CGRect theRect = [theCurrentMenuTableViewController.tableView rectForRowAtIndexPath:theIndexPath];

CMenu *theMenu = [CMainController instance].menu;

CMenuTableViewController *theMenuTableViewController = [[[CMenuTableViewController alloc] initWithMenu:theMenu] autorelease];
theMenuTableViewController.title = @"Menu";

UIPopoverController *thePopoverController = [[[UIPopoverController alloc] initWithContentViewController:theMenuTableViewController] autorelease];
thePopoverController.popoverContentSize = CGSizeMake(320, 44 * theMenu.items.count);
[thePopoverController presentPopoverFromRect:theRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

self.currentPopoverController = thePopoverController;
}

- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectMenuItem:(CMenuItem *)inMenuItem;
{
if (inMenuItem.submenu != NULL)
	return(NO);


NSLog(@"CLICK");

return(YES);
}


@end
