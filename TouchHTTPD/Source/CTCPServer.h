/*
 File: CTCPServer.h
 
 Abstract: Interface description for a basic TCP/IP server Foundation class
*/ 

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@class CTCPConnection;
@protocol CTCPServerDelegate;

@interface CTCPServer : NSObject {
    id <CTCPServerDelegate> delegate;
    uint16_t port;
    NSString *domain;
    NSString *name;
    NSString *type;
    CFSocketRef IPV4Socket;
    CFSocketRef IPV6Socket;
    NSNetService *netService;
	Class connectionClass;
	NSMutableArray *_connections;
}

@property (readwrite, assign) id <CTCPServerDelegate> delegate;
@property (readwrite, assign) uint16_t port;
@property (readwrite, retain) NSString *domain;
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *type;
@property (readonly, assign) CFSocketRef IPV4Socket;
@property (readonly, assign) CFSocketRef IPV6Socket;
@property (readonly, retain) NSNetService *netService;
@property (readwrite, assign) Class connectionClass;
@property (readonly, retain) NSArray *connections;

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

@protocol CTCPServerDelegate

@optional
- (CTCPConnection *)TCPServer:(CTCPServer *)inServer createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

@end