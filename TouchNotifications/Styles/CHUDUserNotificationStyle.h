//
//  CHUDUserNotificationStyle.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CUserNotificationStyle.h"

extern NSString *kHUDNotificationFullScreenKey /* = @"kHUDNotificationFullScreenKey" */;
extern NSString *kHUDNotificationDontUseMaskingViewKey /* = @"kHUDNotificationDontUseMaskingViewKey" */;

@interface CHUDUserNotificationStyle : CUserNotificationStyle {
	UIView *maskingView;
}

@end
