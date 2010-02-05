//
//  CMenuSplitVIewController.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMenuTableViewController.h"

@class CMenu;

@interface CMenuSplitViewController : UISplitViewController <CMenuHandlerDelegate> {
	CMenu *menu;
	UINavigationController *masterViewController;
	UINavigationController *detailViewController;
}

@property (readwrite, nonatomic, retain) CMenu *menu;
@property (readonly, nonatomic, retain) UINavigationController *masterViewController;
@property (readonly, nonatomic, retain) UINavigationController *detailViewController;

@end
