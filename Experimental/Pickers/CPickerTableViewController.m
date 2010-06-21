//
//  CPickerTableViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "CPickerTableViewController.h"

#import "UIViewController_Extensions.h"

@implementation CPickerTableViewController

@synthesize picker;
@synthesize finishButtonItem;
@synthesize cancelButtonItem;

- (id)initWithPicker:(CPicker *)inPicker
{
if ((self = [super init]) != NULL)
	{
	self.picker = inPicker;
	self.picker.viewController = self;
	}
return(self);
}

- (void)dealloc
{
self.picker = NULL;

[finishButtonItem release];
finishButtonItem = NULL;
[cancelButtonItem release];
cancelButtonItem = NULL;
//
[super dealloc];
}

- (void)viewDidUnload
{
[super viewDidUnload];

self.picker = NULL;

[finishButtonItem release];
finishButtonItem = NULL;
[cancelButtonItem release];
cancelButtonItem = NULL;
}

#pragma mark -

- (UIBarButtonItem *)finishButtonItem
{
if (finishButtonItem == NULL)
	{
	finishButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	}
return(finishButtonItem);
}

- (UIBarButtonItem *)cancelButtonItem
{
if (cancelButtonItem == NULL)
	{
	cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	}
return(cancelButtonItem);

}

#pragma mark -

- (IBAction)done:(id)inSender
{
[self.picker done:inSender];
}

- (IBAction)cancel:(id)inSender
{
[self.picker cancel:inSender];
}

@end
