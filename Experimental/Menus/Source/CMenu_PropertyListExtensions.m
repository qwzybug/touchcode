//
//  CMenu_PropertyListExtensions.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenu_PropertyListExtensions.h"

#import "CMenuHandler.h"

@implementation CMenu (CMenu_PropertyListExtensions)

+ (CMenu *)menuFromDictionary:(NSDictionary *)inDictionary targetRoot:(id)inTargetRoot
{
CMenu *theMenu = [[[CMenu alloc] init] autorelease];
theMenu.title = [inDictionary objectForKey:@"title"];

NSString *theControllerName = [inDictionary objectForKey:@"controller"];
if (theControllerName)
	{
	Class theController = NSClassFromString(theControllerName);
//	if (theController && [theController conformsToProtocol:@protocol(CMenuHandler)])
//		{
//		NSLog(@"Warning: Controller '%@' does not conform to protocol.", theControllerName);
//		}
	theMenu.controller = theController;
	}

NSMutableArray *theItems = [NSMutableArray array];
NSArray *theItemsSpecifications = [inDictionary objectForKey:@"items"]; 
for (NSDictionary *theItemSpecification in theItemsSpecifications)
	{
	CMenuItem *theMenuItem = [CMenuItem menuItemFromDictionary:theItemSpecification targetRoot:inTargetRoot];
	[theItems addObject:theMenuItem];
	}
theMenu.items = theItems;
return(theMenu);
}

@end

@implementation CMenuItem (CMenuItem_PropertyListExtensions)

+ (CMenuItem *)menuItemFromDictionary:(NSDictionary *)inDictionary targetRoot:(id)inTargetRoot;
{
CMenuItem *theMenuItem = [[[CMenuItem alloc] init] autorelease];
theMenuItem.title = [inDictionary objectForKey:@"title"];
if ([inDictionary objectForKey:@"iconName"] != NULL)
	theMenuItem.icon = [UIImage imageNamed:[inDictionary objectForKey:@"iconName"]];
if ([inDictionary objectForKey:@"action"] != NULL)
	theMenuItem.action = NSSelectorFromString([inDictionary objectForKey:@"action"]);
if ([inDictionary objectForKey:@"targetPath"] != NULL)
	theMenuItem.target = [inTargetRoot valueForKeyPath:[inDictionary objectForKey:@"targetPath"]];

if ([inDictionary objectForKey:@"submenu"])
	{
	theMenuItem.submenu = [CMenu menuFromDictionary:[inDictionary objectForKey:@"submenu"] targetRoot:inTargetRoot];
	theMenuItem.submenu.superItem = theMenuItem;
	}
return(theMenuItem);
}

@end
