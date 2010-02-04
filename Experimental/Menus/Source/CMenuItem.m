//
//  CMenuItem.m
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuItem.h"

#import "CMenu.h"

@implementation CMenuItem

@synthesize title;
@synthesize icon;
@synthesize submenu;
@synthesize target;
@synthesize action;
@synthesize UIElement;

+ (CMenuItem *)menuItemWithTitle:(NSString *)inTitle target:(id)inTarget action:(SEL)inAction;
{
CMenuItem *theMenuItem = [[[self alloc] init] autorelease];
theMenuItem.title = inTitle;
theMenuItem.target = inTarget;
theMenuItem.action = inAction;
return(theMenuItem);
}

+ (CMenuItem *)menuItemWithTitle:(NSString *)inTitle submenu:(CMenu *)inSubmenu
{
CMenuItem *theMenuItem = [[[self alloc] init] autorelease];
theMenuItem.title = inTitle;
theMenuItem.submenu = inSubmenu;
inSubmenu.superItem = theMenuItem;
return(theMenuItem);
}

- (void)dealloc
{
[title release];
title = NULL;
//
[icon release];
icon = NULL;
//
[submenu release];
submenu = NULL;
//
[target release];
target = NULL;
//
[super dealloc];
}

@end
