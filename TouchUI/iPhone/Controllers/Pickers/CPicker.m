//
//  CPicker.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CPicker.h"

@implementation CPicker

@synthesize type;
@synthesize navigationController;
@synthesize popoverController;
@synthesize viewController;
@synthesize initialValue;
@synthesize value;
@synthesize validatorName;
@synthesize delegate;
@synthesize userInfo;

#pragma mark -

- (id)init
{
if ((self = [super init]) != NULL)
	{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		type = PickerType_Popover;
	else
		type = PickerType_Modal;
	}
return(self);
}

- (void)setValue:(id)inValue
{
if (value != inValue)
	{
	if (value)
		{
		[value release];
		value = NULL;
		}
	
	if (inValue)
		{
		value = [inValue retain];

		if (self.delegate && [self.delegate respondsToSelector:@selector(picker:valueDidChange:)])
			{
			[self.delegate picker:self valueDidChange:inValue];
			}
		}
	}
}

#pragma mark -

- (void)presentModal:(UIViewController *)inParentViewController fromBarButtonItem:(UIBarButtonItem *)inBarButtonItem animated:(BOOL)inAnimated;
{
if (value == NULL)
	value = [self.initialValue retain];

self.viewController.picker = self;

if (self.type == PickerType_Popover)
	{
	self.navigationController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
//	self.viewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
	self.viewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
	self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:self.navigationController] autorelease];
	[self.popoverController presentPopoverFromBarButtonItem:inBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:inAnimated];
	}
else if (self.type == PickerType_Modal)
	{
	self.navigationController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
	self.viewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
	self.viewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];

	self.navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
	[inParentViewController presentModalViewController:self.navigationController animated:inAnimated];
	}
}

#pragma mark -

- (void)done:(id)inSender
{
if (self.delegate && [self.delegate respondsToSelector:@selector(picker:didFinishWithValue:)])
	{
	[self.delegate picker:self didFinishWithValue:self.value];
	}

if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
	[self.popoverController dismissPopoverAnimated:YES];
	}
else
	{
	[self.viewController dismissModalViewControllerAnimated:YES];
	}
}

- (void)cancel:(id)inSender
{
if (self.delegate && [self.delegate respondsToSelector:@selector(pickerDidCancel:)])
	{
	[self.delegate pickerDidCancel:self];
	}

if (self.type == PickerType_Popover)
	{
	[self.popoverController dismissPopoverAnimated:YES];
	}
else if (self.type == PickerType_Modal)
	{
	[self.viewController dismissModalViewControllerAnimated:YES];
	}
}


@end
