//
//  CToolbarMenuViewController.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMenu;
@class CMenuItem;
@class CHostingView;

@interface CToolbarMenuViewController : UIViewController {
	UIToolbar *toolbar;
	CHostingView *contentView;
	//
	CMenu *menu;
}

@property (readwrite, nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (readwrite, nonatomic, retain) IBOutlet CHostingView *contentView;

@property (readwrite, nonatomic, retain) CMenu *menu;

- (id)initWithMenu:(CMenu *)inMenu;

- (void)selectMenuItem:(CMenuItem *)inMenuItem;

@end
