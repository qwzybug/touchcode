//
//  TouchMetricsTestAppDelegate.h
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

@interface TouchMetricsTestAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

