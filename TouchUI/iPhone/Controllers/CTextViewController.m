//
//  CTextViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/18/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import "CTextViewController.h"

@interface CTextViewController ()
@property (readwrite, nonatomic, retain) NSString *initialText;
@end

#pragma mark -

@implementation CTextViewController

@synthesize textView;
@synthesize initialText;

- (id)initWithText:(NSString *)inText
{
if ((self = [self initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.title = @"Memo";
	self.initialText = inText;
	}
return(self);
}

- (void)dealloc
{
self.textView = NULL;
self.initialText = NULL;
//
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.textView.text = self.initialText;
}

- (void)viewDidAppear:(BOOL)animated
{
[super viewDidAppear:animated];

[self.textView becomeFirstResponder];
}

@end
