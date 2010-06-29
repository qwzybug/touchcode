//
//  CUserNotificationState.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/19/09.
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
