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

@interface CPopoverTestController : UIViewController <CMenuHandlerDelegate> {
	CToolbarMenuViewController *toolbarMenuController;
}

@property (readwrite, nonatomic, retain) CToolbarMenuViewController *toolbarMenuController;

@end
