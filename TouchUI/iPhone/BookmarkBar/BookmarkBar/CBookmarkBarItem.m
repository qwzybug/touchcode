//
//  CBookmarkBarItem.m
//  BookmarkBarTest
//
//  Created by Jonathan Wight on 1/3/10.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CBookmarkBarItem.h"

@implementation CBookmarkBarItem

@synthesize bookmarkBar;
@synthesize title;
@synthesize font;
@synthesize titleColor;
@synthesize backgroundColor;
@synthesize borderColor;
@synthesize borderWidth;
@synthesize selected;
@synthesize action;
@synthesize target;
@synthesize tag;
@synthesize representedObject;
@synthesize view;

- (id)init
{
if ((self = [super init]) != NULL)
	{
//	font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
//	titleColor = [UIColor blackColor];
	borderWidth = 2.0;
	}
return(self);
}

- (void)dealloc
{
self.bookmarkBar = NULL;
self.title = NULL;
self.font = NULL;
self.titleColor = NULL;
self.action = NULL;
self.target = NULL;
self.tag = 0;
self.representedObject = NULL;
self.view = NULL;
//
[super dealloc];
}

@end
