//
//  CUserNotification.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	UserNotificationFlag_UsesNetwork = 0x01,
	UserNotificationFlag_Defaults = 0x00,
	};

@interface CUserNotification : NSObject <NSCopying> {
	NSString *identifier;
	NSString *styleName;
	NSString *title;
	NSString *message;
	UIImage *icon;
	CGFloat progress;
//	NSInteger priority;
	NSUInteger flags;
	SEL action;
	id target;
	id userInfo;
}

@property (readwrite, nonatomic, copy) NSString *identifier;
@property (readwrite, nonatomic, copy) NSString *styleName;
@property (readwrite, nonatomic, copy) NSString *title;
@property (readwrite, nonatomic, copy) NSString *message;
@property (readwrite, nonatomic, retain) UIImage *icon;
@property (readwrite, nonatomic, assign) CGFloat progress; // 0.0 to 1.0 for progress, INFINITY for activity, anything else (default NAN) for no progress/activity
//@property (readwrite, nonatomic, assign) NSInteger priority;
@property (readwrite, nonatomic, assign) NSUInteger flags;
@property (readwrite, nonatomic, assign) SEL action;
@property (readwrite, nonatomic, retain) id target;
@property (readwrite, nonatomic, retain) id userInfo;

@end
