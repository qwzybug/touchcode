//
//  CHTTPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWireProtocol.h"

@class CHTTPServer;
@class CHTTPMessage;
@class CHTTPRequestHandler;

@interface CHTTPConnection : CWireProtocol {
	CHTTPServer *server; // Never retained.
	NSMutableArray *requestHandlers;
	CHTTPMessage *currentRequest;
}

@property (readonly, assign) CHTTPServer *server;
@property (readwrite, retain) NSMutableArray *requestHandlers;

- (id)initWithServer:(CHTTPServer *)inServer;

- (CHTTPMessage *)responseForRequest:(CHTTPMessage *)inRequest;
- (void)sendResponse:(CHTTPMessage *)inResponse;

@end
