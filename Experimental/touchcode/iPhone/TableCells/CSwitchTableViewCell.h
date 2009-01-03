//
//  CSwitchTableViewCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 12/1/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSwitchTableViewCell : UITableViewCell {
	IBOutlet UILabel *outletLabel;
	IBOutlet UIView *outletValueView;
}

@property (readonly, nonatomic, retain) UILabel *label;
@property (readonly, nonatomic, retain) UIView *valueView;
@property (readonly, nonatomic, retain) UISwitch *valueSwitch;

+ (CSwitchTableViewCell *)cell;

@end
