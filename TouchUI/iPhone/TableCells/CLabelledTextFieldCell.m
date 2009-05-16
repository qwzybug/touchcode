//
//  CUsernamePasswordTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/1/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CLabelledTextFieldCell.h"

@implementation CLabelledTextFieldCell

@dynamic value;
@dynamic valuePlaceholder;
@synthesize labelView = outletLabelView;
@synthesize valueView = outletValueView;

+ (CLabelledTextFieldCell *)cell
{
// TODO -- this is really silly.
NSArray *theObjects = [[NSBundle mainBundle] loadNibNamed:@"CLabelledTextFieldCell" owner:self options:NULL];
for (id theObject in theObjects)
	if ([theObject isKindOfClass:self])
		return(theObject);
NSAssert(NO, @"Could not find object of class CLabelledTextFieldCell in nib");
return(NULL);
}

- (void)dealloc
{
self.labelView = NULL;
self.valueView = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)text
{
return(self.labelView.text);
}

- (void)setText:(NSString *)inText
{
self.labelView.text = inText;
}

- (NSString *)value
{
return(self.valueView.text);
}

- (void)setValue:(NSString *)inValue
{
self.valueView.text = inValue;
}

- (NSString *)valuePlaceholder
{
return(self.valueView.placeholder);
}

- (void)setValuePlaceholder:(NSString *)inValuePlacholder
{
self.valueView.placeholder = inValuePlacholder;
}

#pragma mark -

- (IBAction)actionEndEdit:(id)inSender
{
[inSender resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
[textField resignFirstResponder];
return(NO);
}

@end
