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
#import "CHTTPMessage_ConvenienceExtensions.h"
#import "TouchHTTPDConstants.h"
#import "NSError_HTTPDExtensions.h"
#import "CMultiInputStream.h"

@interface CHTTPConnection ()
@property (readwrite, assign) CHTTPServer *server;
@property (readwrite, retain) CHTTPMessage *currentRequest;
@end

#pragma mark -

@implementation CHTTPConnection

@synthesize server;
@synthesize requestHandlers;
@synthesize currentRequest;

- (id)initWithServer:(CHTTPServer *)inServer
{
if ((self = [self init]) != NULL)
	{
	self.server = inServer;
	self.requestHandlers = [NSMutableArray array];
	self.currentRequest = NULL;
	}
return(self);
}

- (void)dealloc
{
self.server = NULL;
self.requestHandlers = NULL;
self.currentRequest = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)dataReceived:(NSData *)inData
{
// JIWTODO -- Try not to modify self until needed.

NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

@try
	{	
	if (self.currentRequest == NULL)
		{
		self.currentRequest = [CHTTPMessage HTTPMessageRequest];
		}

	[self.currentRequest appendData:inData];

	if ([self.currentRequest isMessageComplete])
		{
		CHTTPMessage *theRequest = [[self.currentRequest retain] autorelease];
		self.currentRequest = NULL;

		CHTTPMessage *theResponse = [self responseForRequest:theRequest];

		[self sendResponse:theResponse];

		NSString *theConnectionHeader = [theRequest headerForKey:@"Connection"];
		if (theRequest.HTTPVersion == kHTTPVersion1_0 || [theConnectionHeader isEqualToString:@"Close"])
			{
			[self close];
			}
		}
	}
@catch (NSException *e)
	{
	LOG_(@"Exception caught: %@", e);
	self.currentRequest = NULL;
	[self close];
	}
@finally
	{
	[thePool release];
	}
}

#pragma mark -

- (CHTTPMessage *)responseForRequest:(CHTTPMessage *)inRequest
{
CHTTPMessage *theResponse = NULL;
NSError *theError = NULL;

@try
	{
	for (CHTTPRequestHandler *theHandler in self.requestHandlers)
		{
		[theHandler handleRequest:inRequest forConnection:self response:&theResponse error:&theError];
		}
	}
@catch (NSException *e)
	{
	LOG_(@"EXCEPTION CAUGHT: %@", e);
	
	NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
		e, @"NSUnderlyingException",
		NULL];
	NSError *theError = [NSError errorWithDomain:kHTTPErrorDomain code:kHTTPStatusCode_InternalServerError userInfo:theUserInfo];
	
	theError = [NSError errorWithDomain:kHTTPErrorDomain code:kHTTPStatusCode_InternalServerError underlyingError:theError request:inRequest format:@"Exception caught."];
	
	theResponse = [CHTTPMessage HTTPMessageResponseWithError:theError];
	}

if (theResponse == NULL)
	{
	if (theError != NULL && [[theError domain] isEqualToString:kHTTPErrorDomain])
		theResponse = [CHTTPMessage HTTPMessageResponseWithError:theError];
	else
		{
		if (theError != NULL)
			{
			LOG_(@"500: NULL response (%@).", theError);
			theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:kHTTPStatusCode_InternalServerError];
			}
		else
			{
			LOG_(@"500: NULL response.");
			theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:kHTTPStatusCode_InternalServerError];
			}
		}
	}

NSLog(@"**** responseForRequest: %@ %@ %@ -> %d", inRequest.requestMethod, inRequest.requestURL, [inRequest headerForKey:@"Content-Length"], theResponse.responseStatusCode);

return(theResponse);
}

- (void)sendResponse:(CHTTPMessage *)inResponse
{
NSMutableArray *theStreams = [NSMutableArray arrayWithObjects:
	[NSInputStream inputStreamWithData:inResponse.headerData],
	NULL];

if (inResponse.body)
	{
	if ([inResponse.body isKindOfClass:[NSData class]])
		[theStreams addObject:[NSInputStream inputStreamWithData:inResponse.body]];
	else if ([inResponse.body isKindOfClass:[NSStream class]])
		[theStreams addObject:inResponse.body];
	else 
		NSAssert(NO, @"Unknown body");
	}

CMultiInputStream *theMultistream = [[[CMultiInputStream alloc] initWithStreams:theStreams] autorelease];
[self sendStream:theMultistream];
}

@end
