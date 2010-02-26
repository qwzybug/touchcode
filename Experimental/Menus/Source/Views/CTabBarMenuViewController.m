    //
//  CTabBarMenuViewController.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTabBarMenuViewController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CMenuTableViewController.h"

@implementation CTabBarMenuViewController

@synthesize menu;
@synthesize delegate;

- (id)initWithMenu:(CMenu *)inMenu
{
if ((self = [super initWithNibName:NULL bundle:NULL]))
	{
	menu = [inMenu retain];
    }
return(self);
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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


- (void)loadView
{
[super loadView];

NSMutableArray *theViewControllers = [NSMutableArray array];
for (CMenuItem *theMenuItem in self.menu.items)
	{
	CMenuTableViewController *theViewController = [[[CMenuTableViewController alloc] initWithMenu:theMenuItem.submenu] autorelease];
	[theViewControllers addObject:theViewController];
	}
self.viewControllers = theViewControllers;

}


@end
