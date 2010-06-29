//
//  CMenuItem.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/02/10.
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

#import "CMenuItem.h"

#import "CMenu.h"

@implementation CMenuItem

@synthesize title;
@synthesize icon;
@synthesize submenu;
@synthesize target;
@synthesize action;
@synthesize userInfo;
@synthesize UIElement;
@synthesize controller;

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

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (\"%@\")", [super description], self.title]);
}

@end
