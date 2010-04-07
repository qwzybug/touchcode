//
//  CURLOpener.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface CURLOpener : UIActionSheet <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UIViewController *parentViewController;
	NSURL *URL;
	NSArray *selectors;
}

@property (readonly, nonatomic, assign) UIViewController *parentViewController;
@property (readonly, nonatomic, retain) NSURL *URL;

- (id)initWithParentViewController:(UIViewController *)inViewController URL:(NSURL *)inURL;

@end
