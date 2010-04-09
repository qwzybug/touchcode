//
//  CPickerTableViewController.m
//  touchcode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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
