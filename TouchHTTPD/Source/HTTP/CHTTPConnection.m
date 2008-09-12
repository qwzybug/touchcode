//
//  CHTTPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
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

#pragma mark -

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

#pragma mark -

- (void)requestReceived:(CHTTPMessage *)inRequest
{
CHTTPMessage *theResponse = NULL;
NSError *theError = NULL;
for (CHTTPRequestHandler *theHandler in self.requestHandlers)
	{
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

//[self close];
}

@end
