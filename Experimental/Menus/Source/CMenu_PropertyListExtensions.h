//
//  CMenu_PropertyListExtensions.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenu.h"
#import "CMenuItem.h"

@interface CMenu (CMenu_PropertyListExtensions)

+ (CMenu *)menuFromDictionary:(NSDictionary *)inDictionary targetRoot:(id)inTargetRoot;

@end

#pragma mark -

@interface CMenuItem (CMenuItem_PropertyListExtensions)

+ (CMenuItem *)menuItemFromDictionary:(NSDictionary *)inDictionary targetRoot:(id)inTargetRoot;

@end
