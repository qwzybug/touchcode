//
//  CTestServerViewController.h
//  TouchHTTPD_iPhoneServer
//
//  Created by Jonathan Wight on 08/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTTPServer;

@interface CTestServerViewController : UIViewController {
	CHTTPServer *server;
}

@property (readwrite, retain) CHTTPServer *server;

- (IBAction)actionStartServing:(id)inSender;

@end
