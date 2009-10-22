//
//  CFeedEntriesViewController.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/4/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFetchedResultsTableViewController.h"

@class CFeed;

@interface CFeedEntriesViewController : CFetchedResultsTableViewController <NSFetchedResultsControllerDelegate> {
	CFeed *feed;
}

@property (readwrite, nonatomic, retain) CFeed *feed;

- (id)initWithFeed:(CFeed *)inFeed;

@end
