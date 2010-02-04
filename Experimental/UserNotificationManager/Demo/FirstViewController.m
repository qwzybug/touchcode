//
//  FirstViewController.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
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
[[CUserNotificationManager instance] showNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(hideNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionHUDMini:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"HUD-MINI";
[[CUserNotificationManager instance] showNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(hideNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionBubbleTop:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"BUBBLE-TOP";
[[CUserNotificationManager instance] showNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(hideNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionBubbleBottom:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"BUBBLE-BOTTOM";
[[CUserNotificationManager instance] showNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(hideNotification:) withObject:theNotification afterDelay:DELAY];
}

- (IBAction)actionBadgeBottomRight:(id)inSender
{
CUserNotification *theNotification = [self notification];
theNotification.styleName = @"BADGE-BOTTOM-RIGHT";
[[CUserNotificationManager instance] showNotification:theNotification];

[[CUserNotificationManager instance] performSelector:@selector(hideNotification:) withObject:theNotification afterDelay:DELAY];
}

@end
