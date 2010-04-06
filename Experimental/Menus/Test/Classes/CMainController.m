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
#import "CTabBarMenuViewController.h"

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

	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
	NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfFile:thePath];
	CMenu *theMenu = [CMenu menuFromDictionary:theDictionary targetRoot:self];
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

self.rootController.menu = self.menu;


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
