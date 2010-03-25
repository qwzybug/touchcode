//
//  CMenuSplitVIewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuSplitViewController.h"

#import "CMenuTableViewController.h"
#import "CMenu.h"
#import "CDetailViewController.h"

@interface CMenuSplitViewController ()
@property (readwrite, nonatomic, retain) UINavigationController *masterViewController;
@property (readwrite, nonatomic, retain) CDetailViewController *detailViewController;
@end

@implementation CMenuSplitViewController

@synthesize menu;
@synthesize masterViewController;
@synthesize detailViewController;

- (id)initWithMenu:(CMenu *)inMenu
{
if ((self = [super init]) != NULL)
	{
	menu = [inMenu retain];
	}
return(self);
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.delegate = self;

CMenuTableViewController *theMasterMenuTableViewController = [[[CMenuTableViewController alloc] initWithMenu:self.menu] autorelease];
theMasterMenuTableViewController.title = menu.title;
theMasterMenuTableViewController.delegate = self;
theMasterMenuTableViewController.submenuAccessoryType = UITableViewCellAccessoryNone;

masterViewController = [[UINavigationController alloc] initWithRootViewController:theMasterMenuTableViewController];
detailViewController = [[CDetailViewController alloc] init];
self.viewControllers = [NSArray arrayWithObjects:self.masterViewController, self.detailViewController, NULL];
}

- (void)setMenu:(CMenu *)inMenu
{
if (menu != inMenu)
	{
	[menu release];
	menu = NULL;
	
	menu = [inMenu retain];
	self.title = menu.title;
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{
[self.detailViewController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
{
[self.detailViewController.navigationBar.topItem setLeftBarButtonItem:NULL animated:YES];

}

- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectSubmenu:(CMenu *)inMenu;
{
CMenuTableViewController *theMasterMenuTableViewController = [[[CMenuTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
theMasterMenuTableViewController.menu = inMenu;
theMasterMenuTableViewController.title = inMenu.title;

[self.detailViewController setViewController:theMasterMenuTableViewController];

return(NO);
}

@end
