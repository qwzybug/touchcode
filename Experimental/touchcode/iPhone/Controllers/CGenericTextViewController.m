//
//  CGenericTextViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CGenericTextViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "CBorderView.h"

@interface CGenericTextViewController ()

@property (readwrite, nonatomic, retain) UITextView *textView;

@end

#pragma mark -

@implementation CGenericTextViewController

@synthesize textView;

- (void)dealloc
{
self.textView.delegate = NULL;
self.textView = NULL;
//
[super dealloc];
}

- (void)loadView
{
[super loadView];

CGRect theViewFrame = [UIScreen mainScreen].applicationFrame;

self.view = [[[UIView alloc] initWithFrame:theViewFrame] autorelease];
self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

// #####################################################################

theViewFrame = self.view.bounds;
theViewFrame = CGRectInset(theViewFrame, 10, 10);
theViewFrame.size.height = 220;

// #####################################################################

CBorderView *theBorderView = [[[CBorderView alloc] initWithFrame:theViewFrame] autorelease];;
theBorderView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
[self.view addSubview:theBorderView];

theViewFrame = theBorderView.bounds;
theViewFrame = CGRectInset(theViewFrame, 10, 10);

self.textView = [[[UITextView alloc] initWithFrame:theViewFrame] autorelease];
self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
self.textView.delegate = self;
self.textView.font = [UIFont systemFontOfSize:16];

[theBorderView addSubview:self.textView];

self.textView.text = self.value;

self.okButton.enabled = self.textView.text.length > 0;
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated;    // Called when the view is about to made visible. Default does nothing
{
[super viewWillAppear:animated];

//[self.textView becomeFirstResponder];
[self.textView performSelector:@selector(becomeFirstResponder) withObject:NULL afterDelay:0.01];
}

- (void)viewWillDisappear:(BOOL)animated
{
[self.textView resignFirstResponder];

[super viewWillDisappear:animated];
}

- (void)textViewDidChange:(UITextView *)inTextView
{
self.value = self.textView.text;
self.okButton.enabled = self.textView.text.length > 0;
}

@end
