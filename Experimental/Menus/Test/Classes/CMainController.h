//
//  MenusAppDelegate.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMenu;

@interface CMainController : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *rootController;
	CMenu *menu;
}

@property (readwrite, nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (readwrite, nonatomic, retain) CMenu *menu;

+ (CMainController *)instance;

@end

