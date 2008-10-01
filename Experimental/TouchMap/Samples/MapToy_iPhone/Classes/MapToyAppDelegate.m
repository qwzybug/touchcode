//
//  MapToyAppDelegate.m
//  MapToy
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "MapToyAppDelegate.h"
#import "CMapToyViewController.h"

@implementation MapToyAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	// Override point for customization after app launch	
    [window addSubview:viewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
	[window release];
	[super dealloc];
}


@end
