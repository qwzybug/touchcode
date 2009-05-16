//
//  TouchUI_DemoAppDelegate.h
//  TouchUI_Demo
//
//  Created by Jonathan Wight on 5/16/09.
//  Copyright Small Society 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchUI_DemoViewController;

@interface TouchUI_DemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TouchUI_DemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TouchUI_DemoViewController *viewController;

@end

