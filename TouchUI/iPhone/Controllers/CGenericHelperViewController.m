//
//  CGenericHelperViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CGenericHelperViewController.h"

@implementation CGenericHelperViewController

@synthesize delegate;
@synthesize identifier;
@synthesize representedObject;
@synthesize value;
@synthesize cancelButton;
@synthesize okButton;

- (id)init
{
if (self = [super init])
	{
	}
return(self);
}

- (void)dealloc
{
self.delegate = NULL;
self.identifier = NULL;
self.representedObject = NULL;
self.value = NULL;
self.cancelButton = NULL;
self.okButton = NULL;
//
[super dealloc];
}

- (void)loadView
{
[super loadView];

self.cancelButton = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancel:)] autorelease];
self.navigationItem.leftBarButtonItem = self.cancelButton;

self.okButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(actionDone:)] autorelease];
self.navigationItem.rightBarButtonItem = self.okButton;
}

- (void)actionCancel:(id)inSender
{
if (self.delegate && [(id)self.delegate respondsToSelector:@selector(viewControllerDidCancel:)])
	[self.delegate viewControllerDidCancel:self];
	
[self.navigationController popViewControllerAnimated:YES];
}

- (void)actionDone:(id)inSender
{
if (self.delegate && [(id)self.delegate respondsToSelector:@selector(viewControllerDidFinish:)])
	[self.delegate viewControllerDidFinish:self];

[self.navigationController popViewControllerAnimated:YES];
}


@end
