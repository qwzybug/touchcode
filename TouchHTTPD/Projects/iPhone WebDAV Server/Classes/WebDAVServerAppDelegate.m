//
//  WebDAVServerAppDelegate.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/7/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "WebDAVServerAppDelegate.h"
#import "RootViewController.h"


@implementation WebDAVServerAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
