//
//  CMenu_PropertyListExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
Class theClass = [CMenuItem class];

NSString *theClassName = [inDictionary objectForKey:@"className"];
if (theClassName)
	theClass = NSClassFromString(theClassName);

CMenuItem *theMenuItem = [[[theClass alloc] init] autorelease];
theMenuItem.title = [inDictionary objectForKey:@"title"];
if ([inDictionary objectForKey:@"iconName"] != NULL)
	theMenuItem.icon = [UIImage imageNamed:[inDictionary objectForKey:@"iconName"]];
if ([inDictionary objectForKey:@"action"] != NULL)
	theMenuItem.action = NSSelectorFromString([inDictionary objectForKey:@"action"]);
if ([inDictionary objectForKey:@"targetPath"] != NULL)
	theMenuItem.target = [inTargetRoot valueForKeyPath:[inDictionary objectForKey:@"targetPath"]];
if ([inDictionary objectForKey:@"userInfo"] != NULL)
	theMenuItem.userInfo = [inDictionary objectForKey:@"userInfo"];
if ([inDictionary objectForKey:@"controller"] != NULL)
	{
	theMenuItem.controller = NSClassFromString([inDictionary objectForKey:@"controller"]);
	}

if ([inDictionary objectForKey:@"submenu"])
	{
	theMenuItem.submenu = [CMenu menuFromDictionary:[inDictionary objectForKey:@"submenu"] targetRoot:inTargetRoot];
	theMenuItem.submenu.superItem = theMenuItem;
	}
return(theMenuItem);
}

@end
