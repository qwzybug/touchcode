//
//  CSampleHTTPHandler.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CRoutingHTTPRequestHandler.h"

@class CQTCaptureSnapshot;

@interface CWebcamHTTPRouter : NSObject <CHTTPRequestRouter> {
	CQTCaptureSnapshot *snapshot;
}

@property (readwrite, retain) CQTCaptureSnapshot *snapshot;

@end
