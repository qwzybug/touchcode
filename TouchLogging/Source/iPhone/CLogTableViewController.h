//
//  CLogTableViewController.h
//  Touchcode
//
//  Created by Jonathan Wight on 05/11/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "CFetchedResultsTableViewController.h"

@class NSManagedObjectContext;
@class CEntityDataSource;

@interface CLogTableViewController : CFetchedResultsTableViewController {
	NSMutableDictionary *messageDataSourcesForSessions;
}

@property (readwrite, nonatomic, retain) NSMutableDictionary *messageDataSourcesForSessions;

@end
