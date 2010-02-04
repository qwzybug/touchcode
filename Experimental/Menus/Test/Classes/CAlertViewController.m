    //
//  CAlertViewController.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CAlertViewController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CMainController.h"
#import "CMenuSheet.h"

@implementation CAlertViewController

- (void)viewDidAppear:(BOOL)inAnimated
{
[super viewDidAppear:inAnimated];

CMenu *theMenu = [CMainController instance].menu;

CMenuSheet *theActionSheet = [[[CMenuSheet alloc] initWithMenu:theMenu] autorelease];

UITabBar *theTabBar = self.tabBarController.tabBar;
//CGRect theRect = [self.view.window convertRect:theTabBar.bounds fromView:theTabBar];
//[theActionSheet showFromRect:theRect inView:self.view.window animated:YES];

[theActionSheet showFromBarButtonItem:self.tabBarItem animated:YES];
}

@end
