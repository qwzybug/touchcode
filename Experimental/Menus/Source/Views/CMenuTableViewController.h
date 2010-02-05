//
//  CMenuTableViewController.h
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMenuHandler.h"

@interface CMenuTableViewController : UITableViewController <CMenuHandler> {
	CMenu *menu;
	id <CMenuHandlerDelegate> delegate;
	BOOL hidesNavigationBar;
	UITableViewCellAccessoryType submenuAccessoryType;
}

@property (readwrite, nonatomic, retain) CMenu *menu;

@property (readwrite, nonatomic, assign) id <CMenuHandlerDelegate> delegate;
@property (readwrite, nonatomic, assign) BOOL hidesNavigationBar;
@property (readwrite, nonatomic, assign) UITableViewCellAccessoryType submenuAccessoryType;

- (id)initWithMenu:(CMenu *)inMenu;

- (NSIndexPath *)indexPathForMenuItem:(CMenuItem *)inMenuItem;

@end
