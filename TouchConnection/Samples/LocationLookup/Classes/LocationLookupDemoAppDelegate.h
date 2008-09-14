//
//  LocationLookupDemoAppDelegate.h
//  LocationLookupDemo
//
//  Created by Jonathan Wight on 9/14/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationLookupDemoViewController;

@interface LocationLookupDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LocationLookupDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LocationLookupDemoViewController *viewController;

@end

