//
//  MapToyAppDelegate.h
//  MapToy
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMapToyViewController;

@interface MapToyAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet CMapToyViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) CMapToyViewController *viewController;

@end

