//
//  CUserNotificationManager.m
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

#import "CUserNotificationManager.h"

#import "CUserNotification.h"
#import "CUserNotificationStyle.h"

#import "UIView_AnimationExtensions.h"
#import "UIWindow_TestExtensions.h"
#import "CNetworkActivityManager.h"
#import "CUserNotificationState.h"

static CUserNotificationManager *gInstance = NULL;

@interface CUserNotificationManager ()
@property (readwrite, nonatomic, retain) NSMutableDictionary *styleClassNamesByName;
@property (readwrite, nonatomic, retain) NSMutableDictionary *styleOptionsByName;

@property (readwrite, nonatomic, retain) NSMutableArray *notificationStates;
@property (readwrite, nonatomic, retain) CUserNotificationState *currentNotificationState;
@property (readonly, nonatomic, retain) CUserNotificationState *nextNotificationState;

@property (readwrite, nonatomic, assign) NSTimer *timer;

- (void)nextNotification;
- (void)nextTimer;

- (void)showNotificationInternal:(CUserNotificationState *)inState;
- (void)hideNotificationInternal:(CUserNotificationState *)inState;

- (void)timer:(NSTimer *)inTimer;

@end

#pragma mark -

@implementation CUserNotificationManager

@synthesize styleClassNamesByName;
@synthesize styleOptionsByName;
@synthesize defaultStyleName;
@synthesize displayDelay;
@synthesize minimumDisplayTime;
@synthesize notificationStates;
@synthesize currentNotificationState;
@synthesize timer;

+ (CUserNotificationManager *)instance
{
@synchronized(@"CUserNotificationManager")
	{
	if (gInstance == NULL)
		{
		gInstance = [[self alloc] init];
		}
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	styleClassNamesByName = [[NSMutableDictionary alloc] init];
	styleOptionsByName = [[NSMutableDictionary alloc] init];
	displayDelay = 0.25;
	minimumDisplayTime = 2.0;

	notificationStates = [[NSMutableArray alloc] init];

	// TODO What if there is no HUD style registered?
	self.defaultStyleName = @"HUD";
	}
return(self);
}

- (void)dealloc
{
[timer invalidate];
timer = NULL;
//
[styleClassNamesByName release];
styleClassNamesByName = NULL;
//
[styleOptionsByName release];
styleOptionsByName = NULL;
//
[defaultStyleName release];
defaultStyleName = NULL;
//
[notificationStates release];
notificationStates = NULL;
//
[currentNotificationState release];
currentNotificationState = NULL;
//
[super dealloc];
}

#pragma mark -

- (UIView *)mainView
{
if (mainView == NULL)
	{
	UIWindow *theKeyWindow = [UIApplication sharedApplication].keyWindow;
	return(theKeyWindow.mainView);
	}
return(mainView);
}

- (void)setMainView:(UIView *)inMainView
{
if (mainView != inMainView)
	{
	[mainView release];
	mainView = [inMainView retain];
	}
}

- (CUserNotificationState *)nextNotificationState
{
CUserNotificationState *theNewState = NULL;
@synchronized(self)
	{
	if (self.currentNotificationState == NULL && self.notificationStates.count > 0)
		theNewState = [self.notificationStates objectAtIndex:0];
	else
		{
		NSUInteger theNextIndex = [self.notificationStates indexOfObject:self.currentNotificationState] + 1;
		if (theNextIndex < self.notificationStates.count)
			theNewState = [self.notificationStates objectAtIndex:theNextIndex];
		}
	}
return(theNewState);
}

- (void)registerStyleName:(NSString *)inName class:(Class)inClass options:(NSDictionary *)inOptions;
{
if ([self.styleClassNamesByName objectForKey:inName] != NULL)
	{
	NSLog(@"Warning: Already a style registered with the name '%@'. Replacing.", inName);
	}
[self.styleClassNamesByName setObject:NSStringFromClass(inClass) forKey:inName];
if (inOptions)
	[self.styleOptionsByName setObject:inOptions forKey:inName];
}

- (CUserNotificationStyle *)newStyleForNotification:(CUserNotification *)inNotification
{
NSString *theStyleName = inNotification.styleName;
if (theStyleName == NULL)
	theStyleName = self.defaultStyleName;

NSString *theClassName = [self.styleClassNamesByName objectForKey:theStyleName];
if (theClassName == NULL)
	{
	theStyleName = self.defaultStyleName;
	theClassName = [self.styleClassNamesByName objectForKey:theStyleName];
	}

Class theClass = NSClassFromString(theClassName);
NSDictionary *theOptions = [self.styleOptionsByName objectForKey:theStyleName];

CUserNotificationStyle *theNotificationStyle = [[theClass alloc] initWithManager:self styleOptions:theOptions];
return(theNotificationStyle);
}

#pragma mark -

- (void)enqueueNotification:(CUserNotification *)inNotification
{
@synchronized(self)
	{
	if (inNotification.flags & UserNotificationFlag_UsesNetwork)
		[[CNetworkActivityManager instance] addNetworkActivity];

	CUserNotificationState *theState = [[[CUserNotificationState alloc] init] autorelease];
	theState.notification = inNotification;
	theState.requestedShowDate = theState.created;
	[self.notificationStates addObject:theState];
	}
[self nextNotification];
}

- (void)dequeueNotification:(CUserNotification *)inNotification
{
@synchronized(self)
	{
	CUserNotificationState *theState = [[self.notificationStates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"notification == %@", inNotification]] lastObject];
	theState.requestedHideDate = CFAbsoluteTimeGetCurrent();
	}
[self nextNotification];
}

#pragma mark -

- (void)dequeueNotificationForIdentifier:(NSString *)inIdentifier;
{
@synchronized(self)
	{
	CUserNotificationState *theState = [[self.notificationStates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"notification.identifier == %@", inIdentifier]] lastObject];
	if (theState == NULL)
		{
		NSLog(@"Did not find notification for identifier: %@", inIdentifier);
		}
	theState.requestedHideDate = theState.requestedShowDate + self.minimumDisplayTime;
	}
[self nextNotification];
}

- (void)dequeueCurrentNotification
{
@synchronized(self)
	{
	if (self.currentNotificationState)
		[self dequeueNotification:self.currentNotificationState.notification];
	}
}

#pragma mark -

- (BOOL)notificationExistsForIdentifier:(NSString *)inIdentifier
{
BOOL notificationExists = NO;
@synchronized(self)
	{
	for (CUserNotificationState *notificationState in notificationStates)
		{
		if ([notificationState.notification.identifier isEqualToString:inIdentifier])
			{
			notificationExists = YES;
			}
		}
	}
return notificationExists;
}

#pragma mark -

- (void)nextNotification
{
if (self.notificationStates.count <= 0)
	{
	[self nextTimer];
	return;
	}

if ([NSThread isMainThread] == NO)
	{
	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:_cmd]];
	[theInvocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:YES];
	return;
	}

@synchronized(self)
	{
	const CFAbsoluteTime theNow = CFAbsoluteTimeGetCurrent();

	// Go through every notification and hide any that are shown AND are beyond their requestedHideDate
	NSMutableArray *theRemovedNotifications = [NSMutableArray array];
	for (CUserNotificationState *theState in self.notificationStates)
		{
		if (theNow > theState.requestedHideDate)
			{
			[theRemovedNotifications addObject:theState];
			}
		}
	for (CUserNotificationState *theState in theRemovedNotifications)
		{
		[self hideNotificationInternal:theState];
		}
	CUserNotificationState *theNewState = self.nextNotificationState;
	if (theNewState)
		{
		if (theNow > theNewState.requestedHideDate)
			{
			[self.notificationStates removeObject:theNewState];
			}
		else
			{
			[self showNotificationInternal:theNewState];
			}
		}
	}
[self nextTimer];
}

- (void)nextTimer
{
@synchronized(self)
	{
	CFAbsoluteTime theCurrentTime = CFAbsoluteTimeGetCurrent();

	if (self.notificationStates.count == 0)
		return;

	CFAbsoluteTime theNextTime = FLT_MAX;
	for (CUserNotificationState *theState in self.notificationStates)
		{
		if (theState.showDate >= theCurrentTime && theState.showDate < theNextTime)
			theNextTime = theState.showDate;
		if (theState.requestedHideDate >= theCurrentTime && theState.requestedHideDate < theNextTime)
			theNextTime = theState.requestedHideDate;
		}

	if (theNextTime == FLT_MAX)
		return;

	if (self.timer == NULL || theNextTime > [self.timer.fireDate timeIntervalSinceReferenceDate])
		{
		if (self.timer)
			{
			[self.timer invalidate];
			}
		self.timer = [[[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceReferenceDate:theNextTime] interval:0 target:self selector:@selector(timer:) userInfo:NULL repeats:NO] autorelease];
//		NSLog(@"Scheduling timer: %@ (fires in %g seconds)", self.timer, [[NSDate dateWithTimeIntervalSinceReferenceDate:theNextTime] timeIntervalSinceNow]);

		[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
		}
	}
}

#pragma mark -

- (void)showNotificationInternal:(CUserNotificationState *)inState
{
//NSLog(@"* SHOWING NOTIFICATION");
@synchronized(self)
	{
	const CFAbsoluteTime theNow = CFAbsoluteTimeGetCurrent();

	inState.style = [[self newStyleForNotification:inState.notification] autorelease];

	self.currentNotificationState = inState;

	inState.shown = YES;
	inState.showDate = theNow;
	[inState.style showNotification:inState.notification];
	}
}

- (void)hideNotificationInternal:(CUserNotificationState *)inState
{
@synchronized(self)
	{
	const CFAbsoluteTime theNow = CFAbsoluteTimeGetCurrent();

	if (self.currentNotificationState == inState)
		self.currentNotificationState = self.nextNotificationState;

	if (inState.notification.flags & UserNotificationFlag_UsesNetwork)
		[[CNetworkActivityManager instance] removeNetworkActivity];

	inState.hideDate = theNow;

	if (inState.shown == YES)
		{
		[inState.style hideNotification:inState.notification];
		}

	[self.notificationStates removeObject:inState];
	}

[self.notificationStates removeObject:inState];
}

#pragma mark -

- (void)timer:(NSTimer *)inTimer
{
NSAssert(inTimer == self.timer, @"TODO");

[self.timer invalidate];
self.timer = NULL;

[self nextNotification];
}

@end

#pragma mark -

@implementation CUserNotificationManager (CUserNotificationManager_ConvenienceExtensions)

- (CUserNotification *)enqueueNotificationWithMessage:(NSString *)inMessage
{
CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
theNotification.message = inMessage;
theNotification.progress = INFINITY;
[self enqueueNotification:theNotification];
return(theNotification);
}

- (CUserNotification *)enqueueNotificationWithMessage:(NSString *)inMessage identifier:(NSString *)inIdentifier;
{
CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
theNotification.identifier = inIdentifier;
theNotification.message = inMessage;
theNotification.progress = INFINITY;
[self enqueueNotification:theNotification];
return(theNotification);
}
- (CUserNotification *)enqueueNetworkingNotificationWithMessage:(NSString *)inMessage identifier:(NSString *)inIdentifier;
{
CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
theNotification.identifier = inIdentifier;
theNotification.message = inMessage;
theNotification.progress = INFINITY;
theNotification.flags |= UserNotificationFlag_UsesNetwork;
[self enqueueNotification:theNotification];
return(theNotification);
}

- (CUserNotification *)enqueueBadgeNotificationWithTitle:(NSString *)inTitle identifier:(NSString *)inIdentifier;
{
CUserNotification *theNotification = nil;
@synchronized(self)
	{
	CUserNotificationState *theState = [[self.notificationStates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"notification.identifier == %@", inIdentifier]] lastObject];
	if (theState == NULL)
		{
		theNotification = [[[CUserNotification alloc] init] autorelease];
		theNotification.identifier = inIdentifier;
		theNotification.title = inTitle;
		theNotification.progress = INFINITY;
		theNotification.styleName = @"BADGE-TOP-LEFT";
		theNotification.flags |= UserNotificationFlag_UsesNetwork;
		[self enqueueNotification:theNotification];
		}
	else
		{
		theState.requestedHideDate = FLT_MAX;
		theNotification = theState.notification;
		}
	}
return(theNotification);
}

@end

#pragma mark -

@implementation CUserNotificationManager (CUserNotificationManager_InternalExtensions)

- (void)notificationStyle:(CUserNotificationStyle *)inStyle actionFiredForSender:(id)inSender
{
}

@end
