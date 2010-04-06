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
@synthesize segmentedControl;
@synthesize contentView;
@synthesize menu;
@synthesize delegate;

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

NSArray *theMenuItemTitles = [self.menu.items valueForKey:@"title"];

self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:theMenuItemTitles] autorelease];
[self.segmentedControl addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
UIBarButtonItem *theToolbarItem = [[[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl] autorelease];
[theToolbarItems addObject:theToolbarItem];
	
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
BOOL theRowSelectionWasHandled = NO;

[self.segmentedControl setSelectedSegmentIndex:[self.menu.items indexOfObject:inMenuItem]];

if (theRowSelectionWasHandled == NO)
	{
	inMenuItem.UIElement = self;
	if (inMenuItem.target && [inMenuItem.target respondsToSelector:inMenuItem.action])
		{
//		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		[inMenuItem.target performSelector:inMenuItem.action withObject:inMenuItem];
		theRowSelectionWasHandled = YES;
		}
	}

if (theRowSelectionWasHandled == NO)
	{
	if (self.delegate && [self.delegate respondsToSelector:@selector(menuHandler:didSelectMenuItem:)])
		{
		theRowSelectionWasHandled = [self.delegate menuHandler:self didSelectMenuItem:inMenuItem];
		}
	}

CMenu *theSubmenu = inMenuItem.submenu;

if (theRowSelectionWasHandled == NO && theSubmenu != NULL)
	{
	if (self.delegate && [self.delegate respondsToSelector:@selector(menuHandler:didSelectSubmenu:)])
		{
		theRowSelectionWasHandled = [self.delegate menuHandler:self didSelectSubmenu:theSubmenu];
		}
	}

if (theRowSelectionWasHandled == NO && theSubmenu != NULL)
	{
	CMenuTableViewController *theMenuTableViewController = [[[CMenuTableViewController alloc] initWithMenu:theSubmenu] autorelease];
	theMenuTableViewController.title = inMenuItem.title;
	theMenuTableViewController.hidesNavigationBar = YES;

	UINavigationController *theNavigationController = [[[UINavigationController alloc] initWithRootViewController:theMenuTableViewController] autorelease];
	theNavigationController.navigationBarHidden = YES;
	theNavigationController.delegate = self;
	self.contentView.viewController = theNavigationController;
	
	theRowSelectionWasHandled = YES;
	}
	
if (theRowSelectionWasHandled == NO)
	{
//	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"Did not handle submenu!");
	}
}

#pragma mark -

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
[viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
[viewController viewDidAppear:animated];

}

@end
