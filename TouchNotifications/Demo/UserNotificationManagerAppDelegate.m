//
//  UserNotificationManagerAppDelegate.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

#import "UserNotificationManagerAppDelegate.h"


@implementation UserNotificationManagerAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)dealloc
{
[tabBarController release];
[window release];
//
[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
[window addSubview:tabBarController.view];
}

@end

