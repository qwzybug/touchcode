//
//  SliderTestAppDelegate.h
//  SliderTest
//
//  Created by Jonathan Wight on 01/05/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderTestViewController;

@interface SliderTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SliderTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SliderTestViewController *viewController;

@end

