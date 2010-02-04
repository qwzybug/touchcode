//
//  CUserNotificationManager.m
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CUserNotificationManager.h"

#import "CUserNotification.h"

#import "UIView_AnimationExtensions.h"
#import "UIWindow_TestExtensions.h"
#import "CBubbleUserNotificationStyle.h" // REMOVE
#import "CHUDUserNotificationStyle.h" // REMOVE
#import "CBadgeUserNotificationStyle.h"
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

@end

#pragma mark -

@implementation CUserNotificationManager

@synthesize styleClassNamesByName;
@synthesize styleOptionsByName;
@synthesize defaultStyleName;
@synthesize displayDelay;
@synthesize minimumDisplayTime;
@dynamic mainView;
@synthesize notificationStates;
@synthesize currentNotificationState;
@dynamic nextNotificationState;
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
	
	[self registerDefaultStyles];
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
	
	UIWindow *theKeyWindow = [UIApplication sharedApplication].keyWindow;
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
[self.styleClassNamesByName setObject:NSStringFromClass(inClass) forKey:inName];
if (inOptions)
	[self.styleOptionsByName setObject:inOptions forKey:inName];
}

- (void)registerDefaultStyles
{
NSDictionary *theOptions = NULL;

// #############################################################################
theOptions = [NSDictionary dictionaryWithObjectsAndKeys:
	[NSNumber numberWithBool:YES], kHUDNotificationFullScreenKey,
	NULL];
[self registerStyleName:@"HUD" class:[CHUDUserNotificationStyle class] options:theOptions];

// #############################################################################
theOptions = [NSDictionary dictionaryWithObjectsAndKeys:
	[NSNumber numberWithBool:NO], kHUDNotificationFullScreenKey,
	NULL];
[self registerStyleName:@"HUD-MINI" class:[CHUDUserNotificationStyle class] options:theOptions];

// #############################################################################
[self registerStyleName:@"BUBBLE-TOP" class:[CBubbleUserNotificationStyle class] options:NULL];

// #############################################################################
[self registerStyleName:@"BADGE-BOTTOM-RIGHT" class:[CBadgeUserNotificationStyle class] options:NULL];

// #############################################################################
self.defaultStyleName = @"HUD";
}

- (CUserNotificationStyle *)newStyleForNotification:(CUserNotification *)inNotification
{
NSString *theStyleName = inNotification.styleName;
if (theStyleName == NULL)
	theStyleName = self.defaultStyleName;

NSString *theClassName = [self.styleClassNamesByName objectForKey:theStyleName];
if (theClassName == NULL)
	{
//	NSLog(@"Could not find style of name '%@' using default style name ('%@') instead", theStyleName, self.defaultStyleName);
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

//	NSLog(@"ENQUEUEING NOTIFICATION: %@", theState);

	[self nextNotification];
	}
}

- (void)dequeueNotification:(CUserNotification *)inNotification
{
@synchronized(self)
	{
	CUserNotificationState *theState = [[self.notificationStates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"notification == %@", inNotification]] lastObject];
	
//	NSLog(@"DEQUEUEING NOTIFICATION: %@", theState);
	
	theState.requestedHideDate = CFAbsoluteTimeGetCurrent();
	
	[self nextNotification];
	}
}

#pragma mark -

- (void)dequeueNotificationForIdentifier:(NSString *)inIdentifier;
{
@synchronized(self)
	{
	NSLog(@"DEQUE: %@", inIdentifier);
	
	CUserNotificationState *theState = [[self.notificationStates filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"notification.identifier == %@", inIdentifier]] lastObject];
	if (theState == NULL)
		{
		NSLog(@"Did not find notification for identifier: %@", inIdentifier);
		}
	theState.requestedHideDate = CFAbsoluteTimeGetCurrent();
	[self nextNotification];
	}

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

- (void)nextNotification
{
NSAssert(self.notificationStates.count > 0, @"TODO");

if ([NSThread isMainThread] == NO)
	{
	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:_cmd]];
	[theInvocation setTarget:self];
//	[theInvocation setArgument:&inImmediately atIndex:2];
	//	
	[theInvocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:YES];
	return;
	}

@synchronized(self)
	{
//	NSLog(@"**** nextNotification");

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

//	theOldState.requestedHideDate = theOldState.showDate + self.minimumDisplayTime;

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
//	NSLog(@"Scheduling timer: %@ (fires in %g seconds)", self.timer, [[NSDate dateWithTimeIntervalSinceReferenceDate:theNextTime] timeIntervalSinceNow]);

	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
	}
}

#pragma mark -

- (void)showNotificationInternal:(CUserNotificationState *)inState
{
//NSLog(@"* SHOWING NOTIFICATION");

const CFAbsoluteTime theNow = CFAbsoluteTimeGetCurrent();

inState.style = [[self newStyleForNotification:inState.notification] autorelease];

self.currentNotificationState = inState;

inState.shown = YES;
inState.showDate = theNow;
[inState.style showNotification:inState.notification];
}

- (void)hideNotificationInternal:(CUserNotificationState *)inState
{
//NSLog(@"* HIDING NOTIFICATION");

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

#pragma mark -

- (void)timer:(NSTimer *)inTimer
{
NSAssert(inTimer == self.timer, @"TODO");

//NSLog(@"Timer firing: %@", inTimer);

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
NSLog(@"ENQUEUE: %@ %@", inMessage, inIdentifier);

CUserNotification *theNotification = [[[CUserNotification alloc] init] autorelease];
theNotification.identifier = inIdentifier;
theNotification.message = inMessage;
theNotification.progress = INFINITY;
theNotification.flags |= UserNotificationFlag_UsesNetwork;
[self enqueueNotification:theNotification];
return(theNotification);
}

@end

#pragma mark -

@implementation CUserNotificationManager (CUserNotificationManager_InternalExtensions)

- (void)notificationStyle:(CUserNotificationStyle *)inStyle actionFiredForSender:(id)inSender
{
//NSLog(@"ACTION");
}

@end
