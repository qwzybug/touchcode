//
//  FirstViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/09/09.
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

#import "FirstViewController.h"

#import "CUserNotification.h"
#import "CUserNotificationManager.h"



@implementation FirstViewController

- (void)dealloc
{
[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
return(YES);
}

- (CUserNotification *)notification
{
CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
if (count % 2 == 0)
	theNotification.title = [NSString stringWithFormat:@"Short Title (%d)", count];
else
	theNotification.title = [NSString stringWithFormat:@"Long Title (%d) (This is a really really really long title)", count];
//theNotification.message = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
if (count % 3 == 0)
	theNotification.message = @"This is the message and it should be long enough to wrap.";

theNotification.icon = [UIImage imageNamed:@"dogcow.png"];
theNotification.progress = INFINITY;

++count;

return(theNotification);
}

- (IBAction)actionHUDFullScreen:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"HUD";
[[CUserNotificationManager instance] enqueueNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionHUDMini:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"HUD-MINI";
[[CUserNotificationManager instance] enqueueNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionBubbleTop:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"BUBBLE-TOP";
[[CUserNotificationManager instance] enqueueNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionBubbleBottom:(id)inSender
{
NSLog(@"FOO");

CUserNotification *theNotification = [self notification];
theNotification.styleName = @"BUBBLE-BOTTOM";
[[CUserNotificationManager instance] enqueueNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionBadgeBottomRight:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"BADGE-BOTTOM-RIGHT";
[[CUserNotificationManager instance] enqueueNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:DELAY];
}


- (IBAction)actionBadgeTopLeft:(id)inSender
{
	CUserNotification *theNotification = [self notification];
	theNotification.styleName = @"BADGE-TOP-LEFT";
	[[CUserNotificationManager instance] enqueueNotification:theNotification];
	
	[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:DELAY];
}

@end
