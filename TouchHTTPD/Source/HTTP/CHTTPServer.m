//
//  CHTTPServer.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPServer.h"

#import "CHTTPConnection.h"

#import "CHelloWorldHTTPHandler.h" // TODO remove me

@implementation CHTTPServer

@synthesize socketListener;
@synthesize defaultRequestHandlers;

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
CHTTPConnection *theConnection = [[[CHTTPConnection alloc] initWithTCPSocketListener:inSocketListener address:inAddress inputStream:inInputStream outputStream:inOutputStream] autorelease];

theConnection.requestHandlers = defaultRequestHandlers;

return(theConnection);
}


@end
