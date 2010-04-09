//
//  CLoginViewController.h
//  touchcode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPickerTableViewController.h"
#import "CButtonTableViewCell.h"

@interface CLoginViewController : CPickerTableViewController <UITextFieldDelegate> {
	UITextField *usernameField;
	UITextField *passwordField;
	CButtonTableViewCell *doneCell;
	NSIndexPath *editedCellIndexPath;
}

@property (readwrite, nonatomic, retain) NSString *username;
@property (readwrite, nonatomic, retain) NSString *password;

- (BOOL)isValid;
- (BOOL)validate:(NSError **)outError;

@end
