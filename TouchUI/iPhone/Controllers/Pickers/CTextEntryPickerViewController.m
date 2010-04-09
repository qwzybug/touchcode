//
//  CTextEntryPickerViewController.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTextEntryPickerViewController.h"

@implementation CTextEntryPickerViewController

@synthesize label;
@synthesize field;

- (id)initWithPicker:(CPicker *)inPicker
{
if ((self = [super initWithPicker:inPicker]) != NULL)
	{
	self.initialStyle = UITableViewStyleGrouped;
	}
return(self);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
return(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : toInterfaceOrientation == UIDeviceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
return(1);
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
switch (section)
	{
	case 0:
		return(1);
	}
return(0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = NULL;

switch (indexPath.section)
	{
	case 0:
		{
		switch (indexPath.row)
			{
			case 0:
				{
				self.label = theCell.textLabel;
				
				theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NULL] autorelease];
				theCell.textLabel.text = @"Feed";
				theCell.selectionStyle = UITableViewCellSelectionStyleNone;
				self.field = [[[UITextField alloc] initWithFrame:CGRectMake(100, 0, 210, 44)] autorelease];
				self.field.tag = 0;
				self.field.delegate = self;
				self.field.textAlignment = UITextAlignmentLeft;
				self.field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				self.field.textColor = [UIColor colorWithRed:0.31f green:0.408f blue:0.584f alpha:1.0f];
				self.field.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				self.field.autocapitalizationType = UITextAutocapitalizationTypeNone;
				self.field.text = self.picker.value;
				
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.field];
				
				[theCell.contentView addSubview:self.field];
				}
				break;
			}
		}
		break;
	}

return(theCell);
}

#pragma mark -

- (void)keyboardWillShowNotification:(NSNotification *)inNotification
{
}

- (void)keyboardDidShowNotification:(NSNotification *)inNotification
{
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:0.3];
[UIView setAnimationBeginsFromCurrentState:YES];

CGRect theViewFrame = self.view.frame;
theViewFrame.size.height -= 150;
self.view.frame = theViewFrame;

[UIView commitAnimations];

//[self.tableView scrollToRowAtIndexPath:self.editedCellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)keyboardWillHideNotification:(NSNotification *)inNotification
{
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:0.3];
[UIView setAnimationBeginsFromCurrentState:YES];

CGRect theViewFrame = self.view.frame;
theViewFrame.size.height += 150;
self.view.frame = theViewFrame;

[UIView commitAnimations];
}

#pragma mark -

- (void)textFieldTextDidChangeNotification:(NSNotification *)inNotification
{
UITextField *theTextField = inNotification.object;

switch (theTextField.tag)
    {
    case 0:
        self.picker.value = theTextField.text;
        break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//self.editedCellIndexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
[textField resignFirstResponder];

[self done:NULL];

return(YES);
}

// The password field is not firing this event
- (void)textFieldDidEndEditing:(UITextField *)textField
{
switch (textField.tag)
    {
    case 0:
        self.picker.value = textField.text;
        break;
    }
}


@end
