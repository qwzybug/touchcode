//
//  CTextViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/18/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import "CTextViewController.h"

#pragma mark -

@implementation CTextViewController

@synthesize textView;
@synthesize picker;

- (id)init
{
if ((self = [self initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{
self.textView = NULL;
self.picker = NULL;
//
[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
return(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : toInterfaceOrientation == UIDeviceOrientationPortrait);
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.textView.text = self.picker.value;
}

- (void)viewDidAppear:(BOOL)animated
{
[super viewDidAppear:animated];

[self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)inTextView;
{
self.picker.value = inTextView.text;
}

@end
