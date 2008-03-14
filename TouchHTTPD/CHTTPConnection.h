//
//  CHTTPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CBufferedTCPConnection.h"

@interface CHTTPConnection : CBufferedTCPConnection {
	CFHTTPMessageRef request;
	CFHTTPMessageRef response;
}

- (void)requestReceived:(CFHTTPMessageRef)inRequest;
- (void)sendResponse:(CFHTTPMessageRef)inResponse;

@end
