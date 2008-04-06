//
//  CUserDefaultsHTTPHandler.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CRoutingHTTPRequestHandler.h"

@class CQTCaptureSnapshot;

@interface CUserDefaultsHTTPRouter : NSObject <CHTTPRequestRouter> {
	NSMutableDictionary *store;
	NSURL *storeURL;
}

@property (readwrite, retain) NSMutableDictionary *store;
@property (readwrite, retain) NSURL *storeURL;

- (void)reload;
- (void)save;

@end
