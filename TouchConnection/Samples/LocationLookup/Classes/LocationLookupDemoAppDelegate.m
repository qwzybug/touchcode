//
//  LocationLookupDemoAppDelegate.m
//  LocationLookupDemo
//
//  Created by Jonathan Wight on 9/14/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "LocationLookupDemoAppDelegate.h"
#import "LocationLookupDemoViewController.h"

@implementation LocationLookupDemoAppDelegate

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
