//
//  CUserNotificationManager.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CUserNotification;
@class CUserNotificationStyle;
@class CUserNotificationState;

@interface CUserNotificationManager : NSObject {
	NSMutableDictionary *styleClassNamesByName;
	NSMutableDictionary *styleOptionsByName;
	NSString *defaultStyleName;
	NSTimeInterval displayDelay;
	NSTimeInterval minimumDisplayTime;
	UIView *mainView;
	//
	NSMutableArray *notificationStates;

	CUserNotificationState *currentNotificationState;
	
	NSTimer *timer;
}

@property (readwrite, nonatomic, assign) NSTimeInterval displayDelay;
@property (readwrite, nonatomic, assign) NSTimeInterval minimumDisplayTime;
@property (readwrite, nonatomic, copy) NSString *defaultStyleName;
@property (readwrite, nonatomic, retain) UIView *mainView;

+ (CUserNotificationManager *)instance;

- (void)registerStyleName:(NSString *)inName class:(Class)inClass options:(NSDictionary *)inOptions;
- (void)registerDefaultStyles;

- (CUserNotificationStyle *)newStyleForNotification:(CUserNotification *)inNotification;

- (void)enqueueNotification:(CUserNotification *)inNotification;
- (void)dequeueNotification:(CUserNotification *)inNotification;
- (void)dequeueNotificationForIdentifier:(NSString *)inIdentifier;
- (void)dequeueCurrentNotification;

- (BOOL)notificationExistsForIdentifier:(NSString *)inIdentifier;

@end

#pragma mark -

@interface CUserNotificationManager (CUserNotificationManager_ConvenienceExtensions)
- (CUserNotification *)enqueueNotificationWithMessage:(NSString *)inMessage;
- (CUserNotification *)enqueueNotificationWithMessage:(NSString *)inMessage identifier:(NSString *)inIdentifier;
- (CUserNotification *)enqueueNetworkingNotificationWithMessage:(NSString *)inMessage identifier:(NSString *)inIdentifier;
@end

#pragma mark -

@interface CUserNotificationManager (CUserNotificationManager_InternalExtensions)
- (void)notificationStyle:(CUserNotificationStyle *)inStyle actionFiredForSender:(id)inSender;
@end
