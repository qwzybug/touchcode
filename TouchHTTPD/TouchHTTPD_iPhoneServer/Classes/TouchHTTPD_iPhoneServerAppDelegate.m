//
//  TouchHTTPD_iPhoneServerAppDelegate.m
//  TouchHTTPD_iPhoneServer
//
//  Created by Jonathan Wight on 04/13/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "TouchHTTPD_iPhoneServerAppDelegate.h"
#import "MyView.h"

@implementation TouchHTTPD_iPhoneServerAppDelegate

@synthesize window;
@synthesize contentView;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	[window makeKeyAndVisible];
}


- (void)dealloc {
	[contentView release];
	[window release];
	[super dealloc];
}

@end
