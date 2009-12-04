//
//  Logging_iPhoneAppDelegate.h
//  Logging_iPhone
//
//  Created by Jonathan Wight on 10/27/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

@interface Logging_iPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (IBAction)actionLog:(id)inSender;

@end

