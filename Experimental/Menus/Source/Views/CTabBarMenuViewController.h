//
//  CTabBarMenuViewController.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CMenuHandler.h"

@class CMenu;

@interface CTabBarMenuViewController : UITabBarController <CMenuHandler> {
	CMenu *menu;
	id <CMenuHandlerDelegate> delegate;
}

@property (readwrite, nonatomic, retain) CMenu *menu;
@property (readwrite, nonatomic, assign) id <CMenuHandlerDelegate> delegate;

- (id)initWithMenu:(CMenu *)inMenu;

@end
