//
//  CUserNotificationState.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 11/19/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CUserNotification;
@class CUserNotificationStyle;

@interface CUserNotificationState : NSObject {
	CUserNotification *notification;
	CUserNotificationStyle *style;
	BOOL shown;
	BOOL showingNetworkIndicator;
	CFAbsoluteTime created;
	CFAbsoluteTime requestedShowDate;
	CFAbsoluteTime showDate;
	CFAbsoluteTime requestedHideDate;
	CFAbsoluteTime hideDate;

}

@property (readwrite, nonatomic, retain) CUserNotification *notification;
@property (readwrite, nonatomic, retain) CUserNotificationStyle *style;
@property (readwrite, nonatomic, assign) BOOL shown;
@property (readwrite, nonatomic, assign) BOOL showingNetworkIndicator;
@property (readwrite, nonatomic, assign) CFAbsoluteTime created;
@property (readwrite, nonatomic, assign) CFAbsoluteTime requestedShowDate;
@property (readwrite, nonatomic, assign) CFAbsoluteTime showDate;
@property (readwrite, nonatomic, assign) CFAbsoluteTime requestedHideDate;
@property (readwrite, nonatomic, assign) CFAbsoluteTime hideDate;

@end
