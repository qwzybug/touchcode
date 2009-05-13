//
//  CHTTPDefaultHandler.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPDefaultHandler.h"

#import "TouchHTTPDConstants.h"
#import "CHTTPMessage_ConvenienceExtensions.h"
#import "NSDate_InternetDateExtensions.h"

@interface CHTTPDefaultHandler ()
@property (readwrite, retain) NSDictionary *defaultHeaders;
@end

#pragma mark -

@implementation CHTTPDefaultHandler

@synthesize defaultHeaders;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	if (self.defaultHeaders == NULL)
		{
		NSDictionary *theDefaultHeaders = [NSDictionary dictionaryWithObjectsAndKeys:
			@"TouchHTTPD/0.0.1 (Unix) (Mac OS X)", @"Server",
			NULL];
		self.defaultHeaders = theDefaultHeaders;
		}
	}
return(self);
}

- (id)initWithDefaultHeaders:(NSDictionary *)inDefaultHeaders
{
if ((self = [self init]) != NULL)
	{
	self.defaultHeaders = inDefaultHeaders;
	}
return(self);
}

- (void)dealloc
{
self.defaultHeaders = NULL;
//
[super dealloc];
}

#pragma mark -

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)ioResponse error:(NSError **)outError;
{
#pragma unused (inRequest, inConnection, outError)

CHTTPMessage *theResponse = *ioResponse;

for (NSString *theHeader in self.defaultHeaders)
	{
	if ([theResponse headerForKey:theHeader] == NULL)
		{
		NSString *theValue = [self.defaultHeaders objectForKey:theHeader];
		[theResponse setHeader:theValue forKey:theHeader];
		}
	}

if ([theResponse responseStatusCode] >= 200 && [theResponse headerForKey:@"Date"] == NULL)
	{
	[theResponse setHeader:[[NSDate date] RFC1822StringValue] forKey:@"Date"];
	}

// Tue, 15 Nov 1994 08:12:31 GMT

return(YES);
}

@end
