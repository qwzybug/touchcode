//
//  CLabelledTextFieldCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 12/1/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLabelledTextFieldCell : UITableViewCell <UITextFieldDelegate> {
	IBOutlet UILabel *outletLabelView;
	IBOutlet UITextField *outletValueView;
}

@property (readwrite, nonatomic, retain) NSString *value;
@property (readwrite, nonatomic, retain) NSString *valuePlaceholder;

@property (readwrite, nonatomic, retain) UILabel *labelView;
@property (readwrite, nonatomic, retain) UITextField *valueView;

+ (CLabelledTextFieldCell *)cell;

- (IBAction)actionEndEdit:(id)inSender;

@end
