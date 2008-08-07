//
//  TouchHTTPD_iPhoneServerAppDelegate.m
//  TouchHTTPD_iPhoneServer
//
//  Created by Jonathan Wight on 04/13/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "TouchHTTPD_iPhoneServerAppDelegate.h"

@implementation TouchHTTPD_iPhoneServerAppDelegate

@synthesize window;
@synthesize initialViewController;

- (void)dealloc
{
self.window = NULL;
//
[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
[self.window addSubview:self.initialViewController.view];
[self.window makeKeyAndVisible];


[self.initialViewController actionStartServing:NULL];
}

@end
