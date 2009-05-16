//
//  CManagedTableViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CTableViewController.h"

#import "CTableSection.h"
#import "CTableRow.h"

@interface CManagedTableViewController : CTableViewController {
	NSMutableArray *sections;
	id target;
}

@property (readonly, nonatomic, retain) NSMutableArray *sections;
@property (readwrite, nonatomic, assign) id target;

- (CTableSection *)addSection;
- (CTableSection *)addSection:(CTableSection *)inSection;
- (void) removeSection:(CTableSection *)inSection;
- (CTableRow *)addRow:(CTableRow *)inRow;

- (CTableSection *)sectionWithTag:(NSString *)inTag;

- (CTableRow *)rowWithTag:(NSString *)inTag;
- (CTableRow *)rowWithIndexPath:(NSIndexPath *)inIndexPath;
- (CTableSection *)sectionWithIndexPath:(NSIndexPath *)inIndexPath;
- (CTableSection *)sectionWithIndex:(NSInteger)Index;

@end
