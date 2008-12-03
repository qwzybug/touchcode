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
	UIView *headerView;
	UIView *footerView;
}

@property (readwrite, nonatomic, assign) UITableView *table;
@property (readwrite, nonatomic, retain) NSMutableArray *rows;
@property (readwrite, nonatomic, assign) NSString *headerTitle;
@property (readwrite, nonatomic, assign) NSString *footerTitle;
@property (readwrite, nonatomic, assign) UIView *headerView;
@property (readwrite, nonatomic, assign) UIView *footerView;

- (id)init;
- (id)initWithTable:(UITableView *)inTable;

- (CTableRow *)addRow:(CTableRow *)inRow;
- (CTableRow *)addCell:(UITableViewCell *)inCell;

- (NSArray *)visibleRows;

@end
