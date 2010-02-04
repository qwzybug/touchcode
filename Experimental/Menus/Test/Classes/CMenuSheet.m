//
//  CMenuSheet.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuSheet.h"

#import "CMenu.h"
#import "CMenuItem.h"

@implementation CMenuSheet

@synthesize menu;

- (id)initWithMenu:(CMenu *)inMenu;
{
if ((self = [super initWithTitle:@"Menu" delegate:self cancelButtonTitle:NULL destructiveButtonTitle:NULL otherButtonTitles:NULL]) != NULL)
	{
	menu = [inMenu retain];
	
	for (CMenuItem *theMenuItem in self.menu.items)
		{
		[self addButtonWithTitle:theMenuItem.title];
		}
	}
return(self);
}

- (void)dealloc
{
[menu release];
menu = NULL;
//
[super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
CMenuItem *theMenuItem = [self.menu.items objectAtIndex:buttonIndex];
if (theMenuItem.submenu)
	{
	CMenuSheet *theMenuSheet = [[[CMenuSheet alloc] initWithMenu:theMenuItem.submenu] autorelease];
	[theMenuSheet showFromRect:[self.window convertRect:self.bounds fromView:self] inView:self.window animated:YES];
	}
}

@end
