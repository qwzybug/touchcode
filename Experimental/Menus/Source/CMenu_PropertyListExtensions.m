//
//  CMenu_PropertyListExtensions.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenu_PropertyListExtensions.h"

@implementation CMenu (CMenu_PropertyListExtensions)

+ (CMenu *)menuFromDictionary:(NSDictionary *)inDictionary
{
CMenu *theMenu = [[[CMenu alloc] init] autorelease];

theMenu.title = [inDictionary objectForKey:@"title"]; 

NSMutableArray *theItems = [NSMutableArray array];
NSArray *theItemsSpecifications = [inDictionary objectForKey:@"items"]; 
for (NSDictionary *theItemSpecification in theItemsSpecifications)
	{
	CMenuItem *theMenuItem = [CMenuItem menuItemFromDictionary:theItemSpecification];
	[theItems addObject:theMenuItem];
	}
theMenu.items = theItems;
return(theMenu);
}

@end

@implementation CMenuItem (CMenuItem_PropertyListExtensions)

+ (CMenuItem *)menuItemFromDictionary:(NSDictionary *)inDictionary
{
CMenuItem *theMenuItem = [[[CMenuItem alloc] init] autorelease];
theMenuItem.title = [inDictionary objectForKey:@"title"];
if ([inDictionary objectForKey:@"iconName"] != NULL)
	theMenuItem.icon = [UIImage imageNamed:[inDictionary objectForKey:@"iconName"]];
if ([inDictionary objectForKey:@"submenu"])
	{
	theMenuItem.submenu = [CMenu menuFromDictionary:[inDictionary objectForKey:@"submenu"]];
	theMenuItem.submenu.superItem = theMenuItem;
	}
return(theMenuItem);
}

@end
