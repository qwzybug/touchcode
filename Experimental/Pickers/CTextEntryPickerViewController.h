//
//  CTextEntryPickerViewController.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPickerTableViewController.h"

@interface CTextEntryPickerViewController : CPickerTableViewController <UITextFieldDelegate> {
	UITableViewCell *cell;
	UILabel *label;
	UITextField *field;
}

@property (readwrite, nonatomic, retain) UITableViewCell *cell;
@property (readwrite, nonatomic, retain) UILabel *label;
@property (readwrite, nonatomic, retain) UITextField *field;

@end
