//
//  CTCPSocketListener.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@class CTCPConnection;
@protocol CTCPSocketListenerDelegate;

@interface CTCPSocketListener : NSObject {
    id <CTCPSocketListenerDelegate> delegate;
    uint16_t port;
    NSString *domain;
    NSString *name;
    NSString *type;
    CFSocketRef IPV4Socket;
    CFSocketRef IPV6Socket;
    NSNetService *netService;
	Class connectionClass;
	NSMutableArray *_connections;
	BOOL serving;
}

@property (readwrite, assign) id <CTCPSocketListenerDelegate> delegate;
@property (readwrite, assign) uint16_t port;
@property (readwrite, retain) NSString *domain;
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *type;
@property (readonly, assign) CFSocketRef IPV4Socket;
@property (readonly, assign) CFSocketRef IPV6Socket;
@property (readonly, retain) NSNetService *netService;
@property (readwrite, assign) Class connectionClass;
@property (readonly, retain) NSArray *connections;
@property (readonly, assign) BOOL serving;

- (BOOL)start:(NSError **)outError;
- (void)stop;
- (void)serveForever;

- (BOOL)shouldHandleNewConnectionFromAddress:(NSData *)inAddress;

- (CTCPConnection *)createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

- (void)connectionWillOpen:(CTCPConnection *)inConnection;
- (void)connectionDidOpen:(CTCPConnection *)inConnection;

- (void)connectionWillClose:(CTCPConnection *)inConnection;
- (void)connectionDidClose:(CTCPConnection *)inConnection;

@end

#pragma mark -

@protocol CTCPSocketListenerDelegate

@optional
- (CTCPConnection *)TCPSocketListener:(CTCPSocketListener *)inSocketListener createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

@end