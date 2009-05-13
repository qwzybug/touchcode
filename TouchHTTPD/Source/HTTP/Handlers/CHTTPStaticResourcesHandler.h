//
//  CHTTPStaticResourcesHandler.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPRequestHandler.h"


@interface CHTTPStaticResourcesHandler : NSObject <CHTTPRequestHandler> {
	NSString *rootDirectory;
}

@property (readwrite, retain) NSString *rootDirectory;

@end
