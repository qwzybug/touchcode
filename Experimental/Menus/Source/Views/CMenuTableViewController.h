//
//  CMenuTableViewController.h
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTableViewController.h"

#import "CMenuHandler.h"

@interface CMenuTableViewController : CTableViewController <CMenuHandler> {
	CMenu *menu;
	NSArray *sectionRanges;
	id <CMenuHandlerDelegate> menuHandlerDelegate;
	BOOL hidesNavigationBar;
	UITableViewCellAccessoryType submenuAccessoryType;
	CGSize contentSizeForViewInPopoverView;
}

@property (readwrite, nonatomic, retain) CMenu *menu;
@property (readwrite, nonatomic, assign) id <CMenuHandlerDelegate> menuHandlerDelegate;
@property (readwrite, nonatomic, assign) BOOL hidesNavigationBar;
@property (readwrite, nonatomic, assign) UITableViewCellAccessoryType submenuAccessoryType;

- (id)initWithMenu:(CMenu *)inMenu;

- (NSIndexPath *)indexPathForMenuItem:(CMenuItem *)inMenuItem;

@end
