//
//  CUserNotificationStyle.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	UserNotificationStyleFlag_Default = 0x00,
	UserNotificationStyleFlag_ReuseStyle = 0x01,
	};

@class CUserNotificationManager;
@class CUserNotification;

// TODO rename to CUserNotificationContext?
@interface CUserNotificationStyle : NSObject {
	CUserNotificationManager *manager;
	NSDictionary *styleOptions;
	UIView *view;
}

@property (readonly, nonatomic, assign) CUserNotificationManager *manager;
@property (readonly, nonatomic, assign) NSUInteger flags; 
@property (readonly, nonatomic, copy) NSDictionary *styleOptions;
@property (readwrite, nonatomic, retain) UIView *view;

- (id)initWithManager:(CUserNotificationManager *)inManager styleOptions:(NSDictionary *)inStyleOptions;

- (void)showNotification:(CUserNotification *)inNotification;
- (void)hideNotification:(CUserNotification *)inNotification;

- (IBAction)action:(id)inSender;

@end
