//
//  CBookListViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/25/10.
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

#import "CBookListViewController.h"

#import "CTouchBookPageViewController.h"
#import "CBookContainer.h"
#import "CBookLibrary.h"
#import "CMenu.h"
#import "CMenuItem.h"
#import "CBook.h"
#import "CDetailViewController.h"

@implementation CBookListViewController

@synthesize library;

- (void)viewDidLoad
{
self.title = @"Books";

self.library = [[[CBookLibrary alloc] init] autorelease];

CMenu *theMenu = [[[CMenu alloc] init] autorelease];
theMenu.title = @"Library";


for (CBookContainer *theContainer in self.library.books)
	{
	CMenuItem *theMenuItem = [CMenuItem menuItemWithTitle:[theContainer.URL.path lastPathComponent] target:self action:@selector(actionTest:)];
	theMenuItem.userInfo = theContainer;
	[theMenu addItem:theMenuItem];
	for (CBook *theBook in theContainer.books)
		{
//		[theMenu addItem:[CMenuItem menuItemWithTitle:theBook.title target:self action:@selector(actionTest:)]];
		}
	}

self.menu = theMenu;

[super viewDidLoad];
}

- (IBAction)actionTest:(id)inSender
{
CMenuItem *theMenuItem = inSender;

CTouchBookPageViewController *theController = [[[CTouchBookPageViewController alloc] initWithNibName:@"TouchBookViewController" bundle:NULL] autorelease];
theController.URL = [[theMenuItem userInfo] URL];
[self.detailViewController setViewController:theController];


}

@end

