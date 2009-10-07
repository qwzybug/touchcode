//
//  CFetchedResultsTableViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 6/10/09.
//  Copyright 2009 toxicsoftware.com, Inc. All rights reserved.
//

#import "CTableViewController.h"

#import <CoreData/CoreData.h>

@interface CFetchedResultsTableViewController : CTableViewController {
	NSFetchedResultsController *fetchedResultsController;
	UILabel *placeholderLabel;
}

@property (readwrite, nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (readwrite, nonatomic, retain) UILabel *placeholderLabel;

- (void)update;

@end
