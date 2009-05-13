//
//  CHTTPDefaultHandler.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPRequestHandler.h"

@interface CHTTPDefaultHandler : NSObject <CHTTPRequestHandler> {
	NSDictionary *defaultHeaders;
}

@property (readonly, retain) NSDictionary *defaultHeaders;

- (id)init;
- (id)initWithDefaultHeaders:(NSDictionary *)inDefaultHeaders;


@end
