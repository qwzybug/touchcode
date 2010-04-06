//
//  CMenuHandler.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMenu;
@class CMenuItem;

@protocol CMenuHandlerDelegate;

#pragma mark -

@protocol CMenuHandler <NSObject>

@required

@property (readwrite, nonatomic, assign) id <CMenuHandlerDelegate> menuHandlerDelegate;

- (id)initWithMenu:(CMenu *)inMenu;

@end

#pragma mark -

@protocol CMenuHandlerDelegate <NSObject>

@optional
- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectMenuItem:(CMenuItem *)inMenuItem;
- (BOOL)menuHandler:(id <CMenuHandler>)inMenuHandler didSelectSubmenu:(CMenu *)inMenu;

@end
