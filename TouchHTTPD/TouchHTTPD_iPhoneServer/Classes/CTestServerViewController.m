//
//  CTestServerViewController.m
//  TouchHTTPD_iPhoneServer
//
//  Created by Jonathan Wight on 08/07/08.
//  Copyright (c) 2008 Jonathan Wight
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
