//
//  CHTTPServer.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPServer.h"

#define USE_HTTPS 0

#import "CHTTPConnection.h"
#if USE_HTTPS == 1
#import "CSecureTransportConnection.h"
#endif

@implementation CHTTPServer

@synthesize socketListener;
@synthesize defaultRequestHandlers;
@synthesize useHTTPS;
@synthesize SSLCertificates;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.defaultRequestHandlers = [NSMutableArray array];
	}
return(self);
}

- (void)dealloc
{
self.socketListener = NULL;
self.defaultRequestHandlers = NULL;

[super dealloc];
}

- (void)createDefaultSocketListener
{
if (self.socketListener == NULL)
	{
	CTCPSocketListener *theSocketListener = [[[CTCPSocketListener alloc] init] autorelease];
	theSocketListener.type = @"_http._tcp.";
	theSocketListener.port = 8080;
	theSocketListener.delegate = self;
	
	self.socketListener = theSocketListener;
	}
}

- (CTCPConnection *)TCPSocketListener:(CTCPSocketListener *)inSocketListener createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;
{
CTCPConnection *theTCPConnection = [[[CBufferedTCPConnection alloc] initWithAddress:inAddress inputStream:inInputStream outputStream:inOutputStream] autorelease];
theTCPConnection.delegate = inSocketListener;

CProtocol *theLowerLink = theTCPConnection;


if (self.useHTTPS)
	{
#if USE_HTTPS == 1
	CSecureTransportConnection *theSecureTransportConnection = [[[CSecureTransportConnection alloc] init] autorelease];
	theSecureTransportConnection.certificates = self.SSLCertificates;
	theLowerLink.upperLink = theSecureTransportConnection;
	theSecureTransportConnection.lowerLink = theLowerLink;
	
	theLowerLink = theSecureTransportConnection;
#else
	NSAssert(NO, @"HTTPS turned on but disabled by compiler.");
#endif
	}


CHTTPConnection *theHTTPConnection = [[[CHTTPConnection alloc] init] autorelease];
theHTTPConnection.lowerLink = theLowerLink;
theLowerLink.upperLink = theHTTPConnection;


theHTTPConnection.requestHandlers = defaultRequestHandlers;

return(theTCPConnection);
}


@end
