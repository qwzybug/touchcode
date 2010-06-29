//
//  CUserNotification.m
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
// Xcode Static Analyzer thinks the next link is an "incorrect decrement". Huh?
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
