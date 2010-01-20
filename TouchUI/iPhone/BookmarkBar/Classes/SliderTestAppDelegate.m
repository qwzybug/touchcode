//
//  SliderTestAppDelegate.m
//  SliderTest
//
//  Created by Jonathan Wight on 01/05/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import "SliderTestAppDelegate.h"
#import "SliderTestViewController.h"

@implementation SliderTestAppDelegate

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
