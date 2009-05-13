//
//  CTransport.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 12/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CWireProtocol.h"

#import "CStreamConnector.h"

@protocol CTransportDelegate;

@interface CTransport : CWireProtocol <CStreamConnectorDelegate> {
	CFReadStreamRef remoteReadStream;
	CFWriteStreamRef remoteWriteStream;

	id <CTransportDelegate> delegate; // Not retained.
	BOOL isOpen;
	
	CStreamConnector *streamConnector;
}

@property (readonly, assign) CFReadStreamRef remoteReadStream;
@property (readonly, assign) CFWriteStreamRef remoteWriteStream;
@property (readwrite, assign) id <CTransportDelegate> delegate; // Not retained.
@property (readonly, assign) BOOL isOpen;

- (id)initWithInputStream:(CFReadStreamRef)inInputStream outputStream:(CFWriteStreamRef)inOutputStream;

- (BOOL)open:(NSError **)outError;
- (void)close;

@end

#pragma mark -

@protocol CTransportDelegate <NSObject>

- (void)connectionWillOpen:(CTransport *)inConnection;
- (void)connectionDidOpen:(CTransport *)inConnection;

- (void)connectionWillClose:(CTransport *)inConnection;
- (void)connectionDidClose:(CTransport *)inConnection;

@end
