//
//  CMenu.m
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenu.h"

#import "CMenuItem.h"

@interface CMenu ()

@property (readonly, nonatomic, retain) NSMutableArray *mutableItems;

@end

#pragma mark -

@implementation CMenu

@synthesize superItem;
@synthesize title;
@synthesize mutableItems;
@synthesize userInfo;
@synthesize controller;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	mutableItems = [[NSMutableArray alloc] init];
	}
return(self);
}

- (void)dealloc
{
[mutableItems release];
mutableItems = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)title
{
if (title != NULL)
	return(title);
else if (self.superItem.title != NULL)
	return(self.superItem.title);
else
	return(NULL);	
}

- (NSArray *)items
{
return(self.mutableItems);
}

- (void)setItems:(NSArray *)inItems
{
[mutableItems release];
mutableItems = [inItems mutableCopy];
}

- (void)addItem:(CMenuItem *)inItem;
{
[self.mutableItems addObject:inItem];
}

@end
