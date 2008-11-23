//
//  TouchRSS_iPhoneAppDelegate.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/5/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchRSS_iPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

