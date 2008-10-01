//
//  CTableSection.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTableRow;

@interface CTableSection : NSObject {
	UITableView *table; // Never retained
	NSMutableArray *rows;
	NSString *headerTitle;
	NSString *footerTitle;
}

@property (readwrite, nonatomic, assign) UITableView *table;
@property (readwrite, nonatomic, retain) NSMutableArray *rows;
@property (readwrite, nonatomic, assign) NSString *headerTitle;
@property (readwrite, nonatomic, assign) NSString *footerTitle;

- (id)init;
- (id)initWithTable:(UITableView *)inTable;

- (void)addRow:(CTableRow *)inRow;

- (NSArray *)visibleRows;

@end
