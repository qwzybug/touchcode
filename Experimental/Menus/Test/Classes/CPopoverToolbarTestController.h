//
//  CPopoverTestController.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMenuHandler.h"

@class CToolbarMenuViewController;

@interface CPopoverToolbarTestController : UIViewController <CMenuHandlerDelegate> {
	CToolbarMenuViewController *toolbarMenuController;
	UIPopoverController *popoverController;
}

@property (readwrite, nonatomic, retain) CToolbarMenuViewController *toolbarMenuController;
@property (readwrite, nonatomic, retain) UIPopoverController *popoverController;

@end
