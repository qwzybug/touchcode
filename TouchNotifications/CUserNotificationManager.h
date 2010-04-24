//
//  CUserNotificationManager.h
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
- (CUserNotification *)enqueueBadgeNotificationWithTitle:(NSString *)inTitle identifier:(NSString *)inIdentifier;
@end

#pragma mark -

@interface CUserNotificationManager (CUserNotificationManager_InternalExtensions)
- (void)notificationStyle:(CUserNotificationStyle *)inStyle actionFiredForSender:(id)inSender;
@end
