//
//  CMenuTesterViewController.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuTableViewController.h"

@interface CMenuTesterViewController : CMenuTableViewController <CMenuHandlerDelegate> {
	UIPopoverController *currentPopoverController;
}

@property (readwrite, nonatomic, retain) UIPopoverController *currentPopoverController;

@end
