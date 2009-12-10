//
//  CGenericHelperViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
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
if ((self = [super init]) != NULL)
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
