//
//  CUserDefaultsRunnerMainWindowController.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/11/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CHTTPServer.h"
#import "CHTTPBasicAuthHandler.h"
#import "CUserDefaultsHTTPRouter.h"

@interface CUserDefaultsRunnerMainWindowController : NSWindowController <CHTTPBasicAuthHandlerDelegate> {
	NSString *authUsername;
	NSString *authPassword;

	CHTTPServer *server;
	CHTTPBasicAuthHandler *authHandler;
	CUserDefaultsHTTPRouter *userDefaultsRouter;
	
	NSInteger port;
	NSURL *URL;
}

@property (readwrite, copy) NSString *authRealm;
@property (readwrite, copy) NSString *authUsername;
@property (readwrite, copy) NSString *authPassword;

@property (readwrite, assign) BOOL serving;
@property (readwrite, retain) CHTTPServer *server;
@property (readwrite, retain) CHTTPBasicAuthHandler *authHandler;
@property (readwrite, retain) CUserDefaultsHTTPRouter *userDefaultsRouter;

@property (readwrite, assign) NSInteger port;
@property (readonly, retain) NSURL *URL;

- (IBAction)actionURL:(id)inSender;

@end
