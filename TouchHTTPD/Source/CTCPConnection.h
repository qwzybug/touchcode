//
//  CTCPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CProtocol.h"

@protocol CTCPConnectionDelegate;

@interface CTCPConnection : CProtocol {
	id <CTCPConnectionDelegate> delegate; // Not retained.
	NSData *address;
	NSInputStream *inputStream;
	NSOutputStream *outputStream;
}

@property (readwrite, assign) id <CTCPConnectionDelegate> delegate;
@property (readonly, retain) NSData *address;
@property (readonly, retain) NSInputStream *inputStream;
@property (readonly, retain) NSOutputStream *outputStream;

- (id)initWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

- (void)inputStreamHandleEvent:(NSStreamEvent)inEventCode;
- (void)outputStreamHandleEvent:(NSStreamEvent)inEventCode;

- (BOOL)open:(NSError **)outError;
- (void)close;

@end

@protocol CTCPConnectionDelegate

- (void)connectionWillOpen:(CTCPConnection *)inConnection;
- (void)connectionDidOpen:(CTCPConnection *)inConnection;

- (void)connectionWillClose:(CTCPConnection *)inConnection;
- (void)connectionDidClose:(CTCPConnection *)inConnection;

@end
