//
//  CMailLoggingHandler.h
//  Logging
//
//  Created by Jonathan Wight on 10/27/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MessageUI.h>
#import "CLogging.h"

@interface CMailLoggingHandler : NSObject <CLoggingHandler, MFMailComposeViewControllerDelegate> {
	UIViewController *viewController;
	NSArray *recipients;
	NSString *subject;
	NSString *body;
	CLogging *logging;
	NSArray *sessions;
}

@property (readwrite, nonatomic, retain) UIViewController *viewController;
@property (readwrite, nonatomic, retain) NSArray *recipients;
@property (readwrite, nonatomic, retain) NSString *subject;
@property (readwrite, nonatomic, retain) NSString *body;

@end
