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
#import "CMenu_PropertyListExtensions.h"
#import "CUserNotificationManager.h"
#import "CUserNotification.h"

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

	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
	NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfFile:thePath];
	CMenu *theMenu = [CMenu menuFromDictionary:theDictionary targetRoot:self];

//	CMenu *theMenu = [[[CMenu alloc] init] autorelease];
//	CMenuItem *theMenuItem = [CMenuItem menuItemWithTitle:@"Item 1" target:self action:@selector(actionClick:)];
//	theMenuItem.icon = [UIImage imageNamed:@"schwa.png"];
//
//	[theMenu addItem:theMenuItem];
//	[theMenu addItem:[CMenuItem menuItemWithTitle:@"Item 2" target:self action:@selector(actionClick:)]];
//	CMenu *theSubmenu = [[[CMenu alloc] init] autorelease];
//	[theSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Item 1" target:self action:@selector(actionClick:)]];
//	[theSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Item 2" target:self action:@selector(actionClick:)]];
//
//	CMenu *theSubSubmenu = [[[CMenu alloc] init] autorelease];
//	[theSubSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Sub-Item 1" target:self action:@selector(actionClick:)]];
//	[theSubSubmenu addItem:[CMenuItem menuItemWithTitle:@"Sub-Sub-Item 2" target:self action:@selector(actionClick:)]];
//	[theSubmenu  addItem:[CMenuItem menuItemWithTitle:@"Sub-Sub-menu" submenu:theSubSubmenu]];
//	[theMenu addItem:[CMenuItem menuItemWithTitle:@"Sub-menu" submenu:theSubmenu]];

	self.menu = theMenu;

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
//window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//window.backgroundColor = [UIColor whiteColor];
//window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

[window makeKeyAndVisible];

[self.window addSubview:self.rootController.view];

return(YES);
}

- (IBAction)actionSelect:(id)inSender
{
NSLog(@"Item selected: %@", inSender);

CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
theNotification.title = [NSString stringWithFormat:@"Selected: %@", inSender];
theNotification.styleName = @"BUBBLE-TOP";

[[CUserNotificationManager instance] enqueueNotification:theNotification];
[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:1.0];
}

@end
