//
//  CUserDefaultsHTTPHandlerUnitTests.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class CHTTPServer;
@class CUserDefaultsHTTPRouter;

@interface CUserDefaultsHTTPHandlerUnitTests : SenTestCase {
	NSOperationQueue *queue;
	CHTTPServer *server;
	CUserDefaultsHTTPRouter *requestRouter;
}

@property (readwrite, retain) NSOperationQueue *queue;
@property (readwrite, retain) CHTTPServer *server;
@property (readwrite, retain) CUserDefaultsHTTPRouter *requestRouter;

@end
