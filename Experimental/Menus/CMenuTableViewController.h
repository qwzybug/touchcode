//
//  CMenuTableViewController.h
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMenuTableViewControllerDelegate;
@class CMenu;

@interface CMenuTableViewController : UITableViewController {
	id <CMenuTableViewControllerDelegate> delegate;
	CMenu *menu;
}

@property (readwrite, nonatomic, assign) id <CMenuTableViewControllerDelegate> delegate;
@property (readwrite, nonatomic, retain) CMenu *menu;

- (id)initWithMenu:(CMenu *)inMenu;

@end

#pragma mark -

@protocol CMenuTableViewControllerDelegate <NSObject>

@end