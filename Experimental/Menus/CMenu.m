//
//  CMenu.m
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenu.h"

@interface CMenu ()

@property (readonly, nonatomic, retain) NSMutableArray *mutableItems;

@end

#pragma mark -

@implementation CMenu

@synthesize mutableItems;
@synthesize userInfo;

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

[super dealloc];
}

#pragma mark -

- (NSArray *)items
{
return(self.mutableItems);
}

- (void)addItem:(CMenuItem *)inItem;
{
[self.mutableItems addObject:inItem];
}

@end
