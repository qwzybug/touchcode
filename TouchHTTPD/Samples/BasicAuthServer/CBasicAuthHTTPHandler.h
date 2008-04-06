//
//  CBasicAuthHTTPHandler.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CTCPServer.h"
#import "CRoutingHTTPConnection.h"

@interface CBasicAuthHTTPHandler : NSObject <CTCPServerDelegate, CHTTPRequestRouter> {
}

@end
