//
//  CMenuTableViewController.m
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuTableViewController.h"

#import "CMenu.h"
#import "CMenuItem.h"

@implementation CMenuTableViewController

@synthesize menu;
@synthesize delegate;
@synthesize hidesNavigationBar;
@synthesize submenuAccessoryType;

- (id)initWithMenu:(CMenu *)inMenu
{
if ((self = [self initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	menu = [inMenu retain];
    }
return(self);
}

- (void)dealloc
{
[menu release];
menu = NULL;
//
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];

self.submenuAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

}

//- (void)viewDidUnload
//{
//[super viewDidUnload];
//}

- (void)viewWillAppear:(BOOL)animated
{
[super viewWillAppear:animated];

if (self.hidesNavigationBar == YES)
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(YES);
}

- (void)didReceiveMemoryWarning
{
[super didReceiveMemoryWarning];
}

#pragma mark -

- (NSIndexPath *)indexPathForMenuItem:(CMenuItem *)inMenuItem
{
NSUInteger theRow = [self.menu.items indexOfObject:inMenuItem];
NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:theRow inSection:0];
return(theIndexPath);
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
return(1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
return(self.menu.items.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *kCellIdentifier = @"Cell";
UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
if (theCell == nil)
	{
	theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
	}

CMenuItem *theMenuItem = [self.menu.items objectAtIndex:indexPath.row];
theCell.textLabel.text = theMenuItem.title;
theCell.accessoryType = theMenuItem.submenu != NULL ? self.submenuAccessoryType : UITableViewCellAccessoryNone;

return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
BOOL theRowSelectionWasHandled = NO;

CMenuItem *theMenuItem = [self.menu.items objectAtIndex:indexPath.row];

if (theRowSelectionWasHandled == NO)
	{
	theMenuItem.UIElement = self;
	if (theMenuItem.target && [theMenuItem.target respondsToSelector:theMenuItem.action])
		{
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		[theMenuItem.target performSelector:theMenuItem.action withObject:theMenuItem];
		theRowSelectionWasHandled = YES;
		}
	}

if (theRowSelectionWasHandled == NO)
	{
	if (self.delegate && [self.delegate respondsToSelector:@selector(menuHandler:didSelectMenuItem:)])
		{
		theRowSelectionWasHandled = [self.delegate menuHandler:self didSelectMenuItem:theMenuItem];
		if (theRowSelectionWasHandled == YES)
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}

CMenu *theSubmenu = theMenuItem.submenu;

if (theRowSelectionWasHandled == NO && theSubmenu != NULL)
	{
	if (self.delegate && [self.delegate respondsToSelector:@selector(menuHandler:didSelectSubmenu:)])
		{
		theRowSelectionWasHandled = [self.delegate menuHandler:self didSelectSubmenu:theSubmenu];
		}
	}

if (theRowSelectionWasHandled == NO && theSubmenu != NULL)
	{
	if (self.navigationController != NULL)
		{
		CMenuTableViewController *theMenuTableViewController = [[[CMenuTableViewController alloc] initWithMenu:theSubmenu] autorelease];
		theMenuTableViewController.title = theMenuItem.title;
		if (self.hidesNavigationBar == YES && self.navigationController.navigationBarHidden == YES)
			[self.navigationController setNavigationBarHidden:NO animated:YES];
		[self.navigationController pushViewController:theMenuTableViewController animated:YES];
		
		theRowSelectionWasHandled = YES;
		}
	}
	
if (theRowSelectionWasHandled == NO)
	{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"Did not handle submenu!");
	}
}


@end

