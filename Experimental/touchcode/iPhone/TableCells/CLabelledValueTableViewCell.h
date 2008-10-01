//
//  CTitleLabelTableViewCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/31/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLabelledValueTableViewCell : UITableViewCell {
	IBOutlet UILabel *outletTextLabel;
	UIView *valueView;

	NSString *placeholderText;
}

@property (readwrite, nonatomic, retain) UILabel *textLabel;
@property (readwrite, nonatomic, retain) UIView *valueView;
@property (readwrite, nonatomic, retain) NSString *placeholderText;

+ (CLabelledValueTableViewCell *)cell;

@end

#pragma mark -

@interface CLabelledValueTableViewCell (CLabelledValueTableViewCell_ConvenienceExtensions)

@property (readwrite, nonatomic, retain) UILabel *valueLabel;

@end