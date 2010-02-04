//
//  MenusAppDelegate.m
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import "CMainController.h"

#import "CMenu.h"
#import "CMenuItem.h"

@implementation CMainController

static CMainController *gInstance = NULL;

@synthesize window;
@synthesize rootController;
@synthesize menu;

+ (CMainController *)instance
{
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	gInstance = self;
	}
return(self);
}


- (void)dealloc
{
[window release];
[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
[window makeKeyAndVisible];

CMenu *theMenu = [[[CMenu alloc] init] autorelease];
[theMenu addItem:[CMenuItem menuItemWithTitle:@"Item 1" target:self action:@selector(actionClick:)]];
[theMenu addItem:[CMenuItem menuItemWithTitle:@"Item 2" target:self action:@selector(actionClick:)]];
CMenu *theSubmenu = [[[CMenu alloc] init] autorelease];
[theSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Item 1" target:self action:@selector(actionClick:)]];
[theSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Item 2" target:self action:@selector(actionClick:)]];

CMenu *theSubSubmenu = [[[CMenu alloc] init] autorelease];
[theSubSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Sub-Item 1" target:self action:@selector(actionClick:)]];
[theSubSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Sub-Item 2" target:self action:@selector(actionClick:)]];
[theSubmenu  addItem:[CMenuItem menuItemWithTitle:@"Sub-Sub-menu" submenu:theSubSubmenu]];
[theMenu addItem:[CMenuItem menuItemWithTitle:@"Sub-menu" submenu:theSubmenu]];

self.menu = theMenu;

[self.window addSubview:self.rootController.view];

return(YES);
}



@end
