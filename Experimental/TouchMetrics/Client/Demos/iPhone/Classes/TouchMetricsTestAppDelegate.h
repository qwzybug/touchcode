//
//  TouchMetricsTestAppDelegate.h
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPersistentRequestManager;

@interface TouchMetricsTestAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIWindow *window;
	UIViewController *viewController;
	UIImagePickerController *imagePickerController;
	CPersistentRequestManager *requestManager;
}

@property (readwrite, nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, nonatomic, retain) IBOutlet UIViewController *viewController;
@property (readwrite, nonatomic, retain) UIImagePickerController *imagePickerController;
@property (readwrite, nonatomic, retain) CPersistentRequestManager *requestManager;

@end

