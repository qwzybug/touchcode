//
//  CHTTPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPConnection.h"

#import "CHTTPMessage.h"

@interface CHTTPConnection ()
@property (readwrite, retain) CHTTPMessage *request;
@property (readwrite, retain) CHTTPMessage *response;
@end

#pragma mark -

@implementation CHTTPConnection

@synthesize request;
@synthesize response;

- (void)dealloc
{
self.request = NULL;
self.response = NULL;
//
[super dealloc];
}

- (void)dataReceived:(NSData *)inData
{
if (self.request == NULL)
	{
	self.request = [CHTTPMessage HTTPMessageRequest];
	}

[self.request appendData:inData];

if ([self.request isHeaderComplete])
	{
	NSInteger theContentLength = [[self.request headerForKey:@"Content-Length"] integerValue];
        
	NSData *theBody = [self.request body];
	if ([theBody length] >= theContentLength)
		{
		[self requestReceived:self.request];
		}
	}
}

- (void)requestReceived:(CHTTPMessage *)inRequest
{
#pragma unused (inRequest)
}

- (void)sendResponse:(CHTTPMessage *)inResponse
{
[self sendData:[inResponse serializedMessage]];
}

@end
