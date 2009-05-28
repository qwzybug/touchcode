//
//  CLabelledTextFieldCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/1/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
