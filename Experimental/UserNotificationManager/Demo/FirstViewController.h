//
//  FirstViewController.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/09/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController {
	NSUInteger count;
}

- (IBAction)actionHUDFullScreen:(id)inSender;
- (IBAction)actionHUDMini:(id)inSender;
- (IBAction)actionBubbleTop:(id)inSender;
- (IBAction)actionBubbleBottom:(id)inSender;
- (IBAction)actionBadgeBottomRight:(id)inSender;

@end
