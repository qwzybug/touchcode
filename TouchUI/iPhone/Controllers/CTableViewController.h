//
//  CTableViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 2/25/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *outletTableView;
}

@property (readwrite, nonatomic, retain) UITableView *tableView;

@end
