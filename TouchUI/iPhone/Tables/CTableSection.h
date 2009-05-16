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
	NSString *tag;
	NSMutableArray *rows;
	NSString *headerTitle;
	NSString *footerTitle;
	UIView *headerView;
	UIView *footerView;
}

@property (readwrite, nonatomic, assign) UITableView *table;
@property (readwrite, nonatomic, retain) NSString *tag;
@property (readwrite, nonatomic, retain) NSMutableArray *rows;
@property (readwrite, nonatomic, retain) NSString *headerTitle;
@property (readwrite, nonatomic, retain) NSString *footerTitle;
@property (readwrite, nonatomic, retain) UIView *headerView;
@property (readwrite, nonatomic, retain) UIView *footerView;

- (id)initWithTag:(NSString *)inTag;
- (id)initWithTag:(NSString *)inTag title:(NSString *)inTitle;

- (CTableRow *)addRow:(CTableRow *)inRow;
- (void)removeRow:(CTableRow *)inRow;
- (CTableRow *)addCell:(UITableViewCell *)inCell;

- (NSArray *)visibleRows;

@end
