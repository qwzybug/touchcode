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
#import "CMenu_PropertyListExtensions.h"
#import "CMenuSeparatorItem.h"

@interface CMenuTableViewController ()
@property (readonly, nonatomic, retain) NSArray *sectionRanges;
@end

#pragma mark -

@implementation CMenuTableViewController

@synthesize menu;
@synthesize sectionRanges;
@synthesize menuHandlerDelegate;
@synthesize hidesNavigationBar;
@synthesize submenuAccessoryType;

- (id)initWithMenu:(CMenu *)inMenu
{
if ((self = [super init]) != NULL)
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

#pragma mark -

- (void)viewDidLoad
{
[super viewDidLoad];

if (self.menu == NULL)
	{
	NSString *thePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
	NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfFile:thePath];
	self.menu = [CMenu menuFromDictionary:theDictionary targetRoot:self];
	}

self.submenuAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (CGSize)contentSizeForViewInPopoverView
{
return(CGSizeMake(320, self.menu.items.count * 44));
}

- (void)setMenu:(CMenu *)inMenu
{
if (menu != inMenu)	
	{
	[menu release];
	menu = NULL;
	//
	menu = [inMenu retain];
	
	self.title = menu.title;
		
	[self.tableView reloadData];
	}
}

- (NSArray *)sectionRanges
{
if (sectionRanges == NULL)
	{
	NSMutableArray *theSectionRanges = [NSMutableArray array];
	NSRange theRange = { .location = 0, .length = 0 };
	for (id theMenuItem in self.menu.items)
		{
		if ([theMenuItem isKindOfClass:[CMenuSeparatorItem class]])
			{
			[theSectionRanges addObject:[NSValue valueWithRange:theRange]];
			theRange = NSMakeRange(theRange.location + theRange.length + 1, 0);
			}
		else
			{
			theRange.length += 1;
			}
		}
	[theSectionRanges addObject:[NSValue valueWithRange:theRange]];
	sectionRanges = [theSectionRanges copy];
	}
return(sectionRanges);
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
// TODO make work with groups
#warning TODO

NSUInteger theRow = [self.menu.items indexOfObject:inMenuItem];
NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:theRow inSection:0];
return(theIndexPath);
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
return([self.sectionRanges count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
NSRange theSectionRange = [[self.sectionRanges objectAtIndex:section] rangeValue];
return(theSectionRange.length);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
NSRange theSectionRange = [[self.sectionRanges objectAtIndex:indexPath.section] rangeValue];
NSInteger theIndex = theSectionRange.location + indexPath.row;

static NSString *kCellIdentifier = @"Cell";
UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
if (theCell == nil)
	{
	theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
	}

CMenuItem *theMenuItem = [self.menu.items objectAtIndex:theIndex];
theCell.textLabel.text = theMenuItem.title;

if (theMenuItem.submenu != NULL || (theMenuItem.action != NULL && theMenuItem.target != NULL) || theMenuItem.controller != NULL)
	theCell.accessoryType = self.submenuAccessoryType;
else
	theCell.accessoryType = UITableViewCellAccessoryNone;

theCell.imageView.image = theMenuItem.icon;

return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
BOOL theRowSelectionWasHandled = NO;

CMenuItem *theMenuItem = [self.menu.items objectAtIndex:indexPath.row];

if (theRowSelectionWasHandled == NO)
	{
	if (self.menuHandlerDelegate && [self.menuHandlerDelegate respondsToSelector:@selector(menuHandler:didSelectMenuItem:)])
		{
		theRowSelectionWasHandled = [self.menuHandlerDelegate menuHandler:self didSelectMenuItem:theMenuItem];
		if (theRowSelectionWasHandled == YES)
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}

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
	if (theMenuItem.controller)
		{
		UIViewController *theController = [[[theMenuItem.controller alloc] initWithMenuItem:theMenuItem] autorelease];
		
		
		[self.navigationController pushViewController:theController animated:YES];
		
		theRowSelectionWasHandled = YES;
		}
	}

CMenu *theSubmenu = theMenuItem.submenu;

if (theRowSelectionWasHandled == NO && theSubmenu != NULL)
	{
	if (self.menuHandlerDelegate && [self.menuHandlerDelegate respondsToSelector:@selector(menuHandler:didSelectSubmenu:)])
		{
		theRowSelectionWasHandled = [self.menuHandlerDelegate menuHandler:self didSelectSubmenu:theSubmenu];
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

