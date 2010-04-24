//
//  CMainController.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
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

#import "CMainController.h"

#import "CMenu.h"
#import "CMenuItem.h"
#import "CMenu_PropertyListExtensions.h"
#import "CUserNotificationManager.h"
#import "CUserNotification.h"
#import "CTabBarMenuViewController.h"

@implementation CMainController

static CMainController *gInstance = NULL;

@synthesize window;
@synthesize rootController;
@synthesize menu;

+ (CMainController *)instance
{
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	gInstance = self;

	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"plist"];
	NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfFile:thePath];
	CMenu *theMenu = [CMenu menuFromDictionary:theDictionary targetRoot:self];
	self.menu = theMenu;
	}
return(self);
}

- (void)dealloc
{
[window release];
[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    

self.rootController.menu = self.menu;


[window makeKeyAndVisible];

[self.window addSubview:self.rootController.view];

return(YES);
}

- (IBAction)actionSelect:(id)inSender
{
NSLog(@"Item selected: %@", inSender);

CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
theNotification.title = [NSString stringWithFormat:@"Selected: %@", inSender];
theNotification.styleName = @"BUBBLE-TOP";

[[CUserNotificationManager instance] enqueueNotification:theNotification];
[[CUserNotificationManager instance] performSelector:@selector(dequeueNotification:) withObject:theNotification afterDelay:1.0];
}

@end
