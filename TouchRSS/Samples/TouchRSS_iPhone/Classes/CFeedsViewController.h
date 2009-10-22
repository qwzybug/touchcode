//
//  RootViewController.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/4/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

#import "CFetchedResultsTableViewController.h"

@interface CFeedsViewController : CFetchedResultsTableViewController <NSFetchedResultsControllerDelegate> {
}

- (IBAction)addFeed:(id)inSender;

@end
