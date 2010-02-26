//
//  CBookListViewController.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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
[super viewDidLoad];

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

	//	[theMenu addItem:[CMenuItem menuItemWithTitle:[theBook.URL.path lastPathComponent] target:self action:@selector(actionTest:)]];
		}
	}

self.menu = theMenu;

}

- (IBAction)actionTest:(id)inSender
{
CMenuItem *theMenuItem = inSender;

CTouchBookPageViewController *theController = [[[CTouchBookPageViewController alloc] initWithNibName:@"TouchBookViewController" bundle:NULL] autorelease];
theController.URL = [[theMenuItem userInfo] URL];
[self.detailViewController setViewController:theController];


}

@end

