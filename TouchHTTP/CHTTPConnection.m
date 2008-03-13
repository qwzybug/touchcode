//
//  CHTTPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPConnection.h"

@interface CHTTPConnection ()
@property (readwrite, assign) CFHTTPMessageRef request;
@property (readwrite, assign) CFHTTPMessageRef response;
@end

#pragma mark -

@implementation CHTTPConnection

@synthesize request;
@synthesize response;

- (void)dataReceived:(NSData *)inData
{
NSLog(@"DATA RECEIVED: %d", [inData length]);

if (self.request == NULL)
	{
	self.request = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, YES);
	}

BOOL theResult = CFHTTPMessageAppendBytes(self.request, inData.bytes, inData.length);
if (theResult == NO)
	{
	[NSException raise:NSGenericException format:@"HTTP ERROR"];
	}

if (CFHTTPMessageIsHeaderComplete(self.request))
	{
	NSLog(@"%@", [(NSDictionary *)CFHTTPMessageCopyAllHeaderFields(self.request) autorelease]);
	
	NSInteger theContentLength = [[(NSString *)CFHTTPMessageCopyHeaderFieldValue(self.request, CFSTR("Content-Length")) autorelease] integerValue];
        
	NSData *theBody = [(NSData *)CFHTTPMessageCopyBody(self.request) autorelease];
	if ([theBody length] >= theContentLength)
		{
		[self requestReceived:self.request];
		}
	}
}

- (void)requestReceived:(CFHTTPMessageRef)inRequest
{
#pragma unused (inRequest)
}

- (void)sendResponse:(CFHTTPMessageRef)inResponse
{
NSData *theData = [(NSData *)CFHTTPMessageCopySerializedMessage(inResponse) autorelease];
[self sendData:theData];
}

@end
