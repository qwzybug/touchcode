//
//  CTemplateTableViewController.h
//  Small Society
//
//  Created by Jonathan Wight on 5/4/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "CTableViewController.h"

#import "CDynamicCell.h"

@interface CTemplateTableViewController : CTableViewController <CDynamicCellDelegate> {
	NSString *templateFilePath;
	NSArray *sections;
	NSMutableDictionary *heightsForRows;
	NSMutableDictionary *cellsByRow;
}

@property (readwrite, nonatomic, retain) NSString *templateFilePath;
@property (readonly, nonatomic, retain) NSDictionary *templateDictionary;

- (void)reload;

@end
