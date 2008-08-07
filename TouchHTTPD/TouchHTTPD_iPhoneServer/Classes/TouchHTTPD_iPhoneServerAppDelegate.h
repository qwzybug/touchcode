//
//  TouchHTTPD_iPhoneServerAppDelegate.h
//  TouchHTTPD_iPhoneServer
//
//  Created by Jonathan Wight on 04/13/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchHTTPD_iPhoneServerAppDelegate : NSObject {
	IBOutlet UIWindow *window;
	IBOutlet UIViewController *initialViewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIViewController *initialViewController;

@end

