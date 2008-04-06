//
//  CUserDefaultsHTTPHandler.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPHandler.h"

#import "CRoutingHTTPConnection.h"
#import "NSURL_Extensions.h"
#import "CHTTPMessage.h"
#import "CHTTPMessage_ConvenienceExtensions.h"

// GET /key/<KEYNAME>
// POST /key/<KEYNAME>
// DELETE /key/<KEYNAME>

@implementation CUserDefaultsHTTPHandler

@synthesize store;
@synthesize storeURL;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.store = [NSMutableDictionary dictionary];
	}
return(self);
}

- (void)dealloc
{
//
[super dealloc];
}

#pragma mark -

- (void)reload
{
if (self.storeURL)
	{
	self.store = [NSMutableDictionary dictionaryWithContentsOfURL:self.storeURL];
	}
}

- (void)save
{
if (self.storeURL)
	{
	[self.store writeToURL:self.storeURL atomically:YES];
	}
}

#pragma mark -

- (CTCPConnection *)TCPServer:(CTCPServer *)inServer createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;
{
CRoutingHTTPConnection *theConnection = [[[CRoutingHTTPConnection alloc] initWithTCPServer:inServer address:inAddress inputStream:inInputStream outputStream:inOutputStream] autorelease];
theConnection.router = self;
return(theConnection);
}

#pragma mark -

- (BOOL)routeConnection:(CRoutingHTTPConnection *)inConnection request:(CHTTPMessage *)inRequest toTarget:(id *)outTarget selector:(SEL *)outSelector error:(NSError **)outError;
{
#pragma unused (inConnection, outError)
NSURL *theURL = inRequest.requestURL;
NSString *theMethod = [inRequest requestMethod];

*outTarget = self;

if ([theMethod isEqualToString:@"GET"] && [[theURL path] isEqualToString:@"/"])
	*outSelector = @selector(defaultResponseForRequest:error:);
else if (theURL.path.pathComponents.count == 3 && [[theURL.path.pathComponents objectAtIndex:1] isEqualToString:@"key"])
	{
	if ([theMethod isEqualToString:@"GET"])
		*outSelector = @selector(keyGetterResponseForRequest:error:);
	else if ([theMethod isEqualToString:@"POST"])
		*outSelector = @selector(keyPutterResponseForRequest:error:);
	else if ([theMethod isEqualToString:@"DELETE"])
		*outSelector = @selector(keyDeleterResponseForRequest:error:);
	}

return(YES);
}

#pragma mark -

- (CHTTPMessage *)defaultResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 statusDescription:@"OK" httpVersion:kHTTPVersion1_0];
NSString *theErrorDescription = NULL;
NSData *theBodyData = [NSPropertyListSerialization dataFromPropertyList:self.store format:NSPropertyListXMLFormat_v1_0 errorDescription:&theErrorDescription];

[theResponse setContentType:@"text/plain" body:theBodyData];

return(theResponse);
}

- (CHTTPMessage *)keyGetterResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (outError)

CHTTPMessage *theResponse = NULL;
NSURL *theURL = [inRequest requestURL];
NSString *theKey = [[theURL.path.pathComponents objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//NSLog(@"%@", theKey);
NSString *theValue = [self.store objectForKey:theKey];
if (theValue)
	{
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 statusDescription:@"OK" httpVersion:kHTTPVersion1_0];

	NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		theValue, @"value",
		NULL];

	NSString *theErrorDescription = NULL;
	NSData *theBodyData = [NSPropertyListSerialization dataFromPropertyList:theDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&theErrorDescription];

	[theResponse setContentType:@"text/plain" body:theBodyData];
	}
else
	{
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:404 bodyString:@"404 Not found"];
	}

return(theResponse);
}

- (CHTTPMessage *)keyPutterResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (outError)

CHTTPMessage *theResponse = NULL;
NSURL *theURL = [inRequest requestURL];
NSString *theKey = [[theURL.path.pathComponents objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//NSLog(@"%@", theKey);

NSData *theBodyData = [inRequest body];
NSString *theErrorString = NULL;
NSDictionary *theDictionary = [NSPropertyListSerialization propertyListFromData:theBodyData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&theErrorString];

id theValue = [theDictionary objectForKey:@"value"];

if (theValue)
	{
	[self.store setObject:theValue forKey:theKey];
	[self save];
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 statusDescription:@"OK" httpVersion:kHTTPVersion1_0];
	[theResponse setHeader:@"0" forKey:@"Content-Length"];
	}
else
	{
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:500 bodyString:@"500 Internal Error"];
	}

return(theResponse);
}

- (CHTTPMessage *)keyDeleterResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (outError)

CHTTPMessage *theResponse = NULL;
NSURL *theURL = [inRequest requestURL];
NSString *theKey = [[theURL.path.pathComponents objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//NSLog(@"%@", theKey);

if ([self.store objectForKey:theKey])
	{
	[self.store removeObjectForKey:theKey];
	[self save];
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 statusDescription:@"OK" httpVersion:kHTTPVersion1_0];
	[theResponse setHeader:@"0" forKey:@"Content-Length"];
	}
else
	{
	theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:500 bodyString:@"500 Internal Error"];
	}

return(theResponse);
}

@end
