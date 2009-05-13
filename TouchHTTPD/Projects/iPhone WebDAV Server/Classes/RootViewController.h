//
//  RootViewController.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/7/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTCPSocketListener.h"
#import "CHTTPBasicAuthHandler.h"

@class CHTTPServer;

@interface RootViewController : UIViewController <CTCPSocketListenerDelegate, CHTTPBasicAuthHandlerDelegate> {
	CHTTPServer *HTTPServer;

	IBOutlet UISwitch *outletWebDAVSwitch;
	IBOutlet UILabel *outletAddressLabel;
	IBOutlet UILabel *outletConnectionsLabel;
}

@property (readwrite, nonatomic, retain) CHTTPServer *HTTPServer;
@property (readwrite, nonatomic, retain) UISwitch *WebDAVSwitch;
@property (readwrite, nonatomic, retain) UILabel *addressLabel;
@property (readwrite, nonatomic, retain) UILabel *connectionsLabel;

- (IBAction)actionWebDAVSwitch:(id)inSender;

@end
