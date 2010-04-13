//
//  CMenuItem.h
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMenu;

@interface CMenuItem : NSObject {
	NSString *title;
	UIImage *icon;
	CMenu *submenu;
	id target;
	SEL action;
	id userInfo;
	id UIElement;
	Class controller;
}

@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) UIImage *icon;
@property (readwrite, nonatomic, retain) CMenu *submenu;
@property (readwrite, nonatomic, retain) id target;
@property (readwrite, nonatomic, assign) SEL action;
@property (readwrite, nonatomic, retain) id userInfo;
@property (readwrite, nonatomic, assign) id UIElement;
@property (readwrite, nonatomic, assign) id controller;

+ (CMenuItem *)menuItemWithTitle:(NSString *)inTitle target:(id)inTarget action:(SEL)inAction;
+ (CMenuItem *)menuItemWithTitle:(NSString *)inTitle submenu:(CMenu *)inSubmenu;

@end
