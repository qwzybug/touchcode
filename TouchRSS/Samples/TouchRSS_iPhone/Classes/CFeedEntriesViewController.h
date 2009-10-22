//
//  CFeedEntriesViewController.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/4/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFetchedResultsTableViewController.h"

@class CFeedStore;
@class CFeed;

@interface CFeedEntriesViewController : CFetchedResultsTableViewController <NSFetchedResultsControllerDelegate> {
	CFeedStore *feedStore;
	CFeed *feed;
}

@property (readwrite, nonatomic, retain) CFeedStore *feedStore;
@property (readwrite, nonatomic, retain) CFeed *feed;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore feed:(CFeed *)inFeed;

@end
