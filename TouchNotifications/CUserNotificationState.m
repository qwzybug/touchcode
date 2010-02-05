//
//  CUserNotificationState.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 11/19/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CUserNotificationState.h"

@implementation CUserNotificationState

@synthesize notification;
@synthesize style;
@synthesize shown;
@synthesize showingNetworkIndicator;
@synthesize created;
@synthesize requestedShowDate;
@synthesize showDate;
@synthesize requestedHideDate;
@synthesize hideDate;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	created = CFAbsoluteTimeGetCurrent();
	requestedShowDate = NAN;
	showDate = NAN;
	requestedHideDate = FLT_MAX;
	hideDate = NAN;
	}
return(self);
}

- (void)dealloc
{
[notification release];
notification = NULL;
[style release];
style = NULL;
//
[super dealloc];
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (created: %f, req. show date: %f, show date: %f, requested hide date: %f, hide date: %f, notification: %@)",
	[super description],
	self.created,
	self.requestedShowDate - self.created,
	isnan(self.showDate) ? NAN : self.showDate - self.created,
	isnan(self.requestedHideDate) ? NAN : self.requestedHideDate - self.created,
	isnan(self.hideDate) ? NAN : self.hideDate - self.created,
	self.notification
	]);
}

@end
