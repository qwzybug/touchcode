//
//  CHTTPServer.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CTCPSocketListener.h"

@interface CHTTPServer : NSObject <CTCPSocketListenerDelegate> {
	CTCPSocketListener *socketListener;
	NSMutableArray *defaultRequestHandlers;
}

@property (readwrite, retain) CTCPSocketListener *socketListener;
@property (readwrite, retain) NSMutableArray *defaultRequestHandlers;

- (void)createDefaultSocketListener;

@end
