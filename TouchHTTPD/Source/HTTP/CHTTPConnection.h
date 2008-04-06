//
//  CHTTPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CBufferedTCPConnection.h"

@class CHTTPMessage;
@class CHTTPRequestHandler;

@interface CHTTPConnection : CBufferedTCPConnection {
	CHTTPMessage *request;
	NSMutableArray *requestHandlers;
}

@property (readwrite, retain) NSMutableArray *requestHandlers;

- (void)requestReceived:(CHTTPMessage *)inRequest;
- (void)sendResponse:(CHTTPMessage *)inResponse;

@end
