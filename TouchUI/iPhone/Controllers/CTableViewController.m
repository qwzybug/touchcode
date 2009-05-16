//
//  CTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 2/25/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CTableViewController.h"

// UITableViewController
// Creates a table view with the correct dimensions and autoresizing, setting the datasource and delegate to self.
// In -viewWillAppear:, it reloads the table's data if it's empty. Otherwise, it deselects all rows (with or without animation).
// In -viewDidAppear:, it flashes the table's scroll indicators.
// Implements -setEditing:animated: to toggle the editing state of the table.

@implementation CTableViewController

@synthesize tableView = outletTableView;

- (void)dealloc
{
self.tableView = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
NSLog(@"MEMORY WARNING!");
}

- (void)loadView
{
[super loadView];
//
if (self.view == NULL)
	{
	CGRect theViewFrame = [[UIScreen mainScreen] applicationFrame];
	UITableView *theTableView = [[[UITableView alloc] initWithFrame:theViewFrame style:UITableViewStylePlain] autorelease];
	theTableView.delegate = self;
	theTableView.dataSource = self;

	self.view = self.tableView = theTableView;
	}
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
if (self.tableView == NULL && [self.view isKindOfClass:[UITableView class]])
	self.tableView = (UITableView *)self.view;

self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)viewWillAppear:(BOOL)inAnimated
{
[super viewWillAppear:inAnimated];
//
[self.tableView reloadData];
//
[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:inAnimated];
}

- (void)viewDidAppear:(BOOL)inAnimated
{
[super viewDidAppear:inAnimated];
//
[self.tableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)inEditing animated:(BOOL)inAnimated
{
[self.tableView setEditing:inEditing animated:inAnimated];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
return(0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
return(NULL);
}

@end

