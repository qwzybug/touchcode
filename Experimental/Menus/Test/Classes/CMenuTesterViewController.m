    //
//  CMenuTesterViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/03/10.
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

return(NO);
}


@end
