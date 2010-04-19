//
//  CToolbarMenuViewController.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMenuHandler.h"

@class CHostingView;

@interface CToolbarMenuViewController : UIViewController <CMenuHandler, UINavigationControllerDelegate> {
	UIToolbar *toolbar;
	UISegmentedControl *segmentedControl;
	CHostingView *contentView;
	//
	CMenu *menu;
	id <CMenuHandlerDelegate> menuHandlerDelegate;
}

@property (readwrite, nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (readwrite, nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (readwrite, nonatomic, retain) IBOutlet CHostingView *contentView;

@property (readwrite, nonatomic, retain) CMenu *menu;
@property (readwrite, nonatomic, assign) id <CMenuHandlerDelegate> menuHandlerDelegate;

- (id)initWithMenu:(CMenu *)inMenu;

- (void)selectMenuItem:(CMenuItem *)inMenuItem;

@end
