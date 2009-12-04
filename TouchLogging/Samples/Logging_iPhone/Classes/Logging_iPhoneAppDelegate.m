//
//  Logging_iPhoneAppDelegate.m
//  Logging_iPhone
//
//  Created by Jonathan Wight on 10/27/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

#import "Logging_iPhoneAppDelegate.h"

#import "CLogging.h"
#import "CMailLoggingHandler.h"

@implementation Logging_iPhoneAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)dealloc
{
[navigationController release];
[window release];
//
[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
[window addSubview:[navigationController view]];
[window makeKeyAndVisible];

CMailLoggingHandler *theHandler = [[[CMailLoggingHandler alloc] init] autorelease];
theHandler.viewController = navigationController;
theHandler.recipients = [NSArray arrayWithObject:@"jwight@mac.com"];
theHandler.subject = @"Logging";
theHandler.body = @"This is the body.";

[[CLogging instance] addHandler:theHandler forEvents:[NSArray arrayWithObject:@"start"]];
}

- (IBAction)actionLog:(id)inSender
{
LogDebug_(@"Hello world");



}

@end

