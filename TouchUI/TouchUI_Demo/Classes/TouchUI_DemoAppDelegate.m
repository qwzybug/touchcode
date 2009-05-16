//
//  TouchUI_DemoAppDelegate.m
//  TouchUI_Demo
//
//  Created by Jonathan Wight on 5/16/09.
//  Copyright Small Society 2009. All rights reserved.
//

#import "TouchUI_DemoAppDelegate.h"
#import "TouchUI_DemoViewController.h"

@implementation TouchUI_DemoAppDelegate

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
