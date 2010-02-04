//
//  CUserNotificationStyle.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CUserNotificationStyle.h"

#import "CUserNotificationManager.h"

@implementation CUserNotificationStyle

@synthesize manager;
@dynamic flags;
@synthesize styleOptions;
@synthesize view;

- (id)initWithManager:(CUserNotificationManager *)inManager styleOptions:(NSDictionary *)inStyleOptions
{
if ((self = [self init]) != NULL)
	{
	manager = inManager;
	styleOptions = [inStyleOptions copy];
	}
return(self);
}

- (void)dealloc
{
manager = NULL;

[styleOptions release];
styleOptions = NULL;
//
[view release];
view = NULL;
//
[super dealloc];
}

- (NSUInteger)flags
{
return(UserNotificationStyleFlag_Default);
}

- (void)showNotification:(CUserNotification *)inNotification
{
}

- (void)hideNotification:(CUserNotification *)inNotification
{
}

- (IBAction)action:(id)inSender;
{
[self.manager notificationStyle:self actionFiredForSender:inSender];
}

@end
