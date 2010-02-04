//
//  CUserNotification.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CUserNotification.h"

@implementation CUserNotification

@synthesize identifier;
@synthesize styleName;
@synthesize title;
@synthesize message;
@synthesize icon;
@synthesize progress;
//@synthesize priority;
@synthesize flags;
@synthesize action;
@synthesize target;
@synthesize userInfo;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	progress = NAN;
//	priority = 0;
	flags = UserNotificationFlag_Defaults;
	}
return(self);
}

- (void)dealloc
{
[identifier release];
identifier = NULL;

[styleName release];
styleName = NULL;

[title release];
title = NULL;

[message release];
message = NULL;

[icon release];
icon = NULL;

[target release];
target = NULL;

[userInfo release];
userInfo = NULL;
//
[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone;
{
CUserNotification *theCopy = [[self class] init];
theCopy.identifier = self.identifier;
theCopy.styleName = self.styleName;
theCopy.title = self.title;
theCopy.message = self.message;
theCopy.icon = self.icon;
theCopy.progress = self.progress;
//theCopy.priority = self.priority;
theCopy.flags = self.flags;
theCopy.action = self.action;
theCopy.target = self.target;
theCopy.userInfo = self.userInfo;
return(theCopy);
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (id:%@, styleName:%@, title:%@, message:%@, flags:%d, userInfo:%@", [super description], self.identifier, self.styleName, self.title, self.message, self.flags,  self.userInfo]);
}

@end
