//
//  UserNotificationManagerAppDelegate.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNotificationManagerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
