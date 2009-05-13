//
//  CWireProtocol.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTransport;

@interface CWireProtocol : NSObject {
	CWireProtocol *lowerLink; // Weak
	CWireProtocol *upperLink;
}

@property (readwrite, assign) CWireProtocol *lowerLink;
@property (readwrite, retain) CWireProtocol *upperLink;
@property (readonly, assign) CTransport *transport;

- (void)close;

- (void)dataReceived:(NSData *)inData;
- (size_t)sendData:(NSData *)inData;

- (void)sendStream:(NSInputStream *)inInputStream;


@end
