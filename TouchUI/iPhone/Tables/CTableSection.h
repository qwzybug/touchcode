//
//  CTableSection.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
