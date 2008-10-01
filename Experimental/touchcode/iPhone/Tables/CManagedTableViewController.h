//
//  CManagedTableViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTableSection.h"
#import "CTableRow.h"

@interface CManagedTableViewController : UITableViewController {
	NSMutableArray *sections;
	id target;
}

@property (readonly, nonatomic, retain) NSMutableArray *sections;
@property (readwrite, nonatomic, assign) id target;

- (void)addSection;
- (void)addSection:(CTableSection *)inSection;
- (void)addRow:(CTableRow *)inRow;

- (CTableRow *)rowWithTag:(NSString *)inTag;
- (CTableRow *)rowWithIndexPath:(NSIndexPath *)inIndexPath;
- (CTableSection *)sectionWithIndexPath:(NSIndexPath *)inIndexPath;

@end
