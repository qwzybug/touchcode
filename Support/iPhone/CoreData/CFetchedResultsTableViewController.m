//
//  CFetchedResultsTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 6/10/09.
//  Copyright 2009 toxicsoftware.com, Inc. All rights reserved.
//

#import "CFetchedResultsTableViewController.h"

@implementation CFetchedResultsTableViewController

@synthesize fetchedResultsController;
@synthesize placeholderLabel;

- (void)dealloc
{
self.fetchedResultsController = NULL;
self.placeholderLabel = NULL;
//
[super dealloc];
}

#pragma mark -

- (UILabel *)placeholderLabel
{
if (placeholderLabel == NULL)
	{
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 44 * 3, 320, 44)] autorelease];
	theLabel.textAlignment = UITextAlignmentCenter;
	theLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] + 3];
	theLabel.textColor = [UIColor grayColor];
	theLabel.opaque = NO;
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.text = @"No Rows";
	self.placeholderLabel = theLabel;
	}
return(placeholderLabel);
}

- (void)setPlaceholderLabel:(UILabel *)inPlaceholderLabel
{
if (placeholderLabel != inPlaceholderLabel)
	{
	[placeholderLabel release];
	placeholderLabel = [inPlaceholderLabel retain];
    }
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
[super viewWillAppear:animated];

[self update];
}

- (void)update
{
[self.fetchedResultsController performFetch:NULL];
[self.tableView reloadData];

if (self.fetchedResultsController.fetchedObjects.count == 0)
	{
	if (self.placeholderLabel.superview != self.tableView)
		[self.tableView addSubview:self.placeholderLabel];
	}
else
	{
	if (self.placeholderLabel.superview == self.tableView)
		[self.placeholderLabel removeFromSuperview];
	}
}

@end
