//
//  CFeedEntryViewController.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/06/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CWebViewController.h"

#import <CoreData/CoreData.h>

@class CFeedEntry;
@class CTrivialTemplate;

@interface CFeedEntryViewController : CWebViewController {
	NSFetchedResultsController *fetchedResultsController;
	CFeedEntry *entry;
	CTrivialTemplate *contentTemplate;
	UISegmentedControl *nextPreviousSegmentedControl;
	UIBarButtonItem *nextPreviousBarButtonItem;
}

@property (readwrite, nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (readwrite, nonatomic, assign) NSInteger currentEntryIndex;
@property (readwrite, nonatomic, retain) CFeedEntry *entry;
@property (readwrite, nonatomic, retain) CTrivialTemplate *contentTemplate;
@property (readonly, nonatomic, retain) UISegmentedControl *nextPreviousSegmentedControl;
@property (readonly, nonatomic, retain) UIBarButtonItem *nextPreviousBarButtonItem;

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)inFetchedResultsController;

- (IBAction)next:(id)inSender;
- (IBAction)previous:(id)inSender;

@end
