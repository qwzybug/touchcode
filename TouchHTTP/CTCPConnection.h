//
//  CTCPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CTCPServer;

@interface CTCPConnection : NSObject {
	CTCPServer *server; // Not retained.
	NSData *address;
	NSInputStream *inputStream;
	NSOutputStream *outputStream;
}

@property (readonly, assign) CTCPServer *server;
@property (readonly, retain) NSData *address;
@property (readonly, retain) NSInputStream *inputStream;
@property (readonly, retain) NSOutputStream *outputStream;

- (id)initWithTCPServer:(CTCPServer *)inServer address:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

- (void)inputStreamHandleEvent:(NSStreamEvent)inEventCode;
- (void)outputStreamHandleEvent:(NSStreamEvent)inEventCode;

- (BOOL)open:(NSError **)outError;
- (void)close;

@end
