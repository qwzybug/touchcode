//
//  CToolbarMenuViewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CToolbarMenuViewController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CHostingView.h"
#import "CMenuTableViewController.h"

@implementation CToolbarMenuViewController

@synthesize toolbar;
@synthesize contentView;
@synthesize menu;

- (id)initWithMenu:(CMenu *)inMenu
{
if ((self = [self initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.menu = inMenu;
    }
return(self);
}

- (void)loadView
{
[super loadView];

NSMutableArray *theToolbarItems = [NSMutableArray array];
[theToolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL] autorelease]];

#if 0
for (CMenuItem *theMenuItem in self.menu.items)
	{
	UIBarButtonItem *theToolbarItem = [[[UIBarButtonItem alloc] initWithTitle:theMenuItem.title style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarItemHit:)] autorelease];
	theToolbarItem.tag = [self.menu.items indexOfObject:theMenuItem];
	[theToolbarItems addObject:theToolbarItem];
	}
#else
	NSArray *theMenuItemTitles = [self.menu.items valueForKey:@"title"];

	UISegmentedControl *theSegmentedControl = [[[UISegmentedControl alloc] initWithItems:theMenuItemTitles] autorelease];
	[theSegmentedControl addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
	theSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	UIBarButtonItem *theToolbarItem = [[[UIBarButtonItem alloc] initWithCustomView:theSegmentedControl] autorelease];
	[theToolbarItems addObject:theToolbarItem];
#endif
	
	
[theToolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL] autorelease]];
	
toolbar.items = theToolbarItems;

}

- (IBAction)toolbarItemHit:(id)inSender
{
CMenuItem *theMenuItem = [self.menu.items objectAtIndex:[inSender tag]];
[self selectMenuItem:theMenuItem];
}

- (IBAction)test:(id)inSender
{
CMenuItem *theMenuItem = [self.menu.items objectAtIndex:[inSender selectedSegmentIndex]];
[self selectMenuItem:theMenuItem];
}

- (void)selectMenuItem:(CMenuItem *)inMenuItem
{
if (inMenuItem.submenu)
	{
	CMenuTableViewController *theMenuController = [[[CMenuTableViewController alloc] initWithMenu:inMenuItem.submenu] autorelease];
	theMenuController.hidesNavigationBar = YES;

	UINavigationController *theNavigationController = [[[UINavigationController alloc] initWithRootViewController:theMenuController] autorelease];
	theNavigationController.navigationBarHidden = YES;

	self.contentView.viewController = theNavigationController;
	}
else
	{
	self.contentView.viewController = NULL;
	}
}

@end
