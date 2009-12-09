//
//  Logging_iPhoneAppDelegate.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/27/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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

