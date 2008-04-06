//
//  CHTTPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPConnection.h"

#import "CHTTPMessage.h"
#import "CHTTPRequestHandler.h"

@interface CHTTPConnection ()
@property (readwrite, retain) CHTTPMessage *request;
@end

#pragma mark -

@implementation CHTTPConnection

@synthesize requestHandlers;
@synthesize request;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.requestHandlers = [NSMutableArray array];
	}
return(self);
}

- (void)dealloc
{
self.requestHandlers = NULL;
self.request = NULL;
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

CHTTPMessage *theResponse = NULL;
NSError *theError = NULL;
for (CHTTPRequestHandler *theHandler in self.requestHandlers)
	{
	NSLog(@"requestReceived - trying: %@", theHandler);
	BOOL theResult = [theHandler handleRequest:inRequest forConnection:self response:&theResponse error:&theError];
	if (theResult == YES)
		break;
	}
if (theResponse != NULL)
	[self sendResponse:theResponse];
}

- (void)sendResponse:(CHTTPMessage *)inResponse
{
[self sendData:[inResponse serializedMessage]];
}

@end
