//
//  CUserNotificationStyle.m
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

#import "CUserNotificationStyle.h"

#import "CUserNotificationManager.h"

@implementation CUserNotificationStyle

@synthesize manager;
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
