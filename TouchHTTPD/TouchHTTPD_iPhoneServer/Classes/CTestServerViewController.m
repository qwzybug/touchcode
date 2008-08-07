//
//  CTestServerViewController.m
//  TouchHTTPD_iPhoneServer
//
//  Created by Jonathan Wight on 08/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CTestServerViewController.h"

#import "CHTTPServer.h"
#import "CFileSystemHTTPHandler.h"

@implementation CTestServerViewController

@synthesize server;

- (IBAction)actionStartServing:(id)inSender
{
if (self.server == NULL)
	{
	self.server = [[[CHTTPServer alloc] init] autorelease];
	
	CFileSystemHTTPHandler *theRequestHandler = [[[CFileSystemHTTPHandler alloc] init] autorelease];
	[self.server.defaultRequestHandlers addObject:theRequestHandler];

	
	
	[self.server createDefaultSocketListener];
	
	self.server.socketListener.name = @"Test";
	
	NSError *theError = NULL;
	[self.server.socketListener start:&theError];
	NSLog(@"ERROR: %@", theError);
	
	NSLog(@"%@", self.server.socketListener.IPV4Socket);
	
//	NSData *theAddressData = [(NSData *)CFSocketCopyAddress(self.server.socketListener.IPV4Socket) autorelease];
	
//	struct sockaddr_in *theAddress = (struct sockaddr * )[theAddressData bytes];
	
	[self.server.socketListener serveForever];
	}
}

@end
