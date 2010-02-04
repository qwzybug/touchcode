//
//  CMenuSplitVIewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuSplitViewController.h"

#import "CMenuTableViewController.h"

@interface CMenuSplitViewController ()
@property (readwrite, nonatomic, retain) UINavigationController *masterViewController;
@property (readwrite, nonatomic, retain) UINavigationController *detailViewController;
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

- (void)loadView
{
[super loadView];
}

- (void)setMenu:(CMenu *)inMenu
{
if (menu != inMenu)
	{
	[menu release];
	menu = NULL;
	
	menu = [inMenu retain];

	CMenuTableViewController *theMasterMenuTableViewController = [[[CMenuTableViewController alloc] initWithMenu:self.menu] autorelease];
	theMasterMenuTableViewController.title = @"Master";
	theMasterMenuTableViewController.delegate = self;
	theMasterMenuTableViewController.submenuAccessoryType = UITableViewCellAccessoryNone;

	

	masterViewController = [[UINavigationController alloc] initWithRootViewController:theMasterMenuTableViewController];
	detailViewController = [[UINavigationController alloc] init];
	self.viewControllers = [NSArray arrayWithObjects:self.masterViewController, self.detailViewController, NULL];
	}
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

- (BOOL)menuTableViewController:(CMenuTableViewController *)inMenuTableViewController didSelectSubmenu:(CMenu *)inMenu;
{
CMenuTableViewController *theMasterMenuTableViewController = [[[CMenuTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
theMasterMenuTableViewController.menu = inMenu;
theMasterMenuTableViewController.title = @"Detail";

[self.detailViewController setViewControllers:[NSArray arrayWithObject:theMasterMenuTableViewController] animated:NO];

return(YES);
}

@end
