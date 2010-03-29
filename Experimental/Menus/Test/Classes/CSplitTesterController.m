    //
//  CSplitTesterViewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CSplitTesterController.h"

#import "CMainController.h"
#import "CBlankViewController.h"
#import "CMenuItem.h"
#import "CDetailViewController.h"

@implementation CSplitTesterController

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.menu = [CMainController instance].menu;
}

- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectMenuItem:(CMenuItem *)inMenuItem;
{
if (inMenuItem.submenu != NULL)
	return(NO);

CBlankViewController *theBlankViewController = [[[CBlankViewController alloc] initWithText:inMenuItem.title] autorelease];
theBlankViewController.title = inMenuItem.title;

[self.detailViewController setViewController:theBlankViewController];

return(YES);
}

@end
