//
//  CUserDefaultsHTTPHandlerUnitTests.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class CTCPServer;
@class CUserDefaultsHTTPHandler;

@interface CUserDefaultsHTTPHandlerUnitTests : SenTestCase {
	NSOperationQueue *queue;
	CTCPServer *server;
	CUserDefaultsHTTPHandler *requestHandler;
}

@property (readwrite, retain) NSOperationQueue *queue;
@property (readwrite, retain) CTCPServer *server;
@property (readwrite, retain) CUserDefaultsHTTPHandler *requestHandler;

@end
