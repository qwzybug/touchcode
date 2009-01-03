//
//  CLabelledValueTableViewCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLabelledContentTableViewCell : UITableViewCell {
	UILabel *label;
	UIView *content;
}

@property (readwrite, nonatomic, retain) UILabel *label;
@property (readwrite, nonatomic, retain) UIView *content;

- (void)adjustLayout;

@end
