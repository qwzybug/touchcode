//
//  CEntryTableViewCell.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEntryTableViewCell : UITableViewCell {
	IBOutlet UILabel *outletTitleLabel;
	IBOutlet UILabel *outletTimestampLabel;
}

+ (CEntryTableViewCell *)cell;

@property (readwrite, nonatomic, retain) UILabel *titleLabel;
@property (readwrite, nonatomic, retain) UILabel *timestampLabel;

@end
