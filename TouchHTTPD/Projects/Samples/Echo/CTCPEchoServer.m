//
//  CTCPEchoServer.m
//  Echo
//
//  Created by Jonathan Wight on 12/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTCPEchoServer.h"

#import "CTCPEchoConnection.h"
#import "CTCPSocketListener_Extensions.h"

@implementation CTCPEchoServer

@synthesize socketListener;

- (void)serve
{
self.socketListener = [[[CTCPSocketListener alloc] init] autorelease];
self.socketListener.connectionCreationDelegate = self;
self.socketListener.port = 1234;

NSError *theError = NULL;
if ([self.socketListener serveForever:NO error:&theError] == NO)
	NSLog(@"%@", theError);
}

- (CTCPConnection *)TCPSocketListener:(CTCPSocketListener *)inSocketListener createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(CFReadStreamRef)inInputStream outputStream:(CFWriteStreamRef)inOutputStream
{
CTCPEchoConnection *theConnection = [[[CTCPEchoConnection alloc] initWithAddress:inAddress inputStream:inInputStream outputStream:inOutputStream] autorelease];
return(theConnection);
}

@end
