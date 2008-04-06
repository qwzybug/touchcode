//
//  CRoutingHTTPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPConnection.h"

@class CRoutingHTTPConnection;
@class CHTTPMessage;

@protocol CHTTPRequestRouter
- (BOOL)routeConnection:(CRoutingHTTPConnection *)inConnection request:(CHTTPMessage *)inRequest toTarget:(id *)outTarget selector:(SEL *)outSelector error:(NSError **)outError;
@end

@interface CRoutingHTTPConnection : CHTTPConnection {
	id <CHTTPRequestRouter> router;
}

@property (readwrite, retain) id <CHTTPRequestRouter> router;

@end

#pragma mark -

