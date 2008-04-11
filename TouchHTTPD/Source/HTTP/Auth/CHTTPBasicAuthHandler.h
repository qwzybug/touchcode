//
//  CHTTPBasicAuthHandler.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPRequestHandler.h"

@protocol CHTTPBasicAuthHandlerDelegate;

@interface CHTTPBasicAuthHandler : CHTTPRequestHandler {
	CHTTPRequestHandler *childHandler;
	id <CHTTPBasicAuthHandlerDelegate> delegate;
	NSString *realm;
}

@property (readwrite, retain) CHTTPRequestHandler *childHandler;
@property (readwrite, assign) id <CHTTPBasicAuthHandlerDelegate> delegate;
@property (readwrite, copy) NSString *realm;

@end

@protocol CHTTPBasicAuthHandlerDelegate 

- (BOOL)HTTPAuthHandler:(CHTTPBasicAuthHandler *)inHandler shouldAuthenticateCredentials:(NSData *)inData;

@end