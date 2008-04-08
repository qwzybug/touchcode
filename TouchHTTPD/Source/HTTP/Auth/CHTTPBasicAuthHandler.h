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
}

@property (readwrite, retain) CHTTPRequestHandler *childHandler;
@property (readwrite, assign) id <CHTTPBasicAuthHandlerDelegate> delegate;

@end

@protocol CHTTPBasicAuthHandlerDelegate 

- (BOOL)HTTPAuthHandler:(CHTTPBasicAuthHandler *)inHandler shouldAuthenticateCredentials:(NSData *)inData;

@end