//
//  CUserDefaultsHTTPHandler.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPHandler.h"

#import "CRoutingHTTPConnection.h"
#import "CJSONSerializer.h"
#import "NSURL_Extensions.h"

@implementation CUserDefaultsHTTPHandler

@synthesize store;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.store = [NSMutableDictionary dictionary];
	}
return(self);
}

- (CTCPConnection *)TCPServer:(CTCPServer *)inServer createTCPConnectionWithAddress:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;
{
CRoutingHTTPConnection *theConnection = [[[CRoutingHTTPConnection alloc] initWithTCPServer:inServer address:inAddress inputStream:inInputStream outputStream:inOutputStream] autorelease];
theConnection.router = self;
return(theConnection);
}

- (BOOL)routeConnection:(CRoutingHTTPConnection *)inConnection request:(CFHTTPMessageRef)inRequest toTarget:(id *)outTarget selector:(SEL *)outSelector error:(NSError **)outError;
{
#pragma unused (inConnection, outError)
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(inRequest) autorelease];
NSString *theMethod = [(NSString *)CFHTTPMessageCopyRequestMethod(inRequest) autorelease];

*outTarget = self;

// GET /key/<KEYNAME>
// PUT /key/<KEYNAME>?value=<VALUE>(&type=<TYPE>)
// DELETE /key/<KEYNAME>

if ([theMethod isEqualToString:@"GET"] && [[theURL path] isEqualToString:@"/"])
	*outSelector = @selector(defaultResponseForRequest:error:);
else if (theURL.path.pathComponents.count == 3 && [[theURL.path.pathComponents objectAtIndex:1] isEqualToString:@"key"])
	{
	if ([theMethod isEqualToString:@"GET"])
		*outSelector = @selector(keyGetterResponseForRequest:error:);
	else if ([theMethod isEqualToString:@"PUT"])
		*outSelector = @selector(keyPutterResponseForRequest:error:);
	else if ([theMethod isEqualToString:@"DELETE"])
		*outSelector = @selector(keyDeleterResponseForRequest:error:);
	}

return(YES);
}

- (CFHTTPMessageRef)defaultResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CFHTTPMessageRef theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

NSString *theBody = @"DEFAULT!";
NSData *theBodyData = [theBody dataUsingEncoding:NSUTF8StringEncoding];
CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);

return(theResponse);
}

- (CFHTTPMessageRef)keyGetterResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (outError)

CFHTTPMessageRef theResponse = NULL;
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(inRequest) autorelease];
NSString *theKey = [theURL.path.pathComponents objectAtIndex:2];
NSString *theValue = [self.store objectForKey:theKey];
if (theValue)
	{
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

	NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		theValue, @"value",
		NULL];

	NSString *theBodyString = [[CJSONSerializer serializer] serializeObject:theDictionary];
	NSData *theBodyData = [theBodyString dataUsingEncoding:NSUTF8StringEncoding];

	CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);
	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);
	}
else
	{
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 404, (CFStringRef)@"Not found", kCFHTTPVersion1_0);

	NSData *theBodyData = [@"404 Not found" dataUsingEncoding:NSUTF8StringEncoding];
	CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);
	}

return(theResponse);
}

- (CFHTTPMessageRef)keyPutterResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (outError)

CFHTTPMessageRef theResponse = NULL;
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(inRequest) autorelease];
NSDictionary *theQueryDictionary = theURL.queryDictionary;
NSString *theKey = [theURL.path.pathComponents objectAtIndex:2];
NSString *theStringValue = [theQueryDictionary objectForKey:@"value"];
NSString *theType = [theQueryDictionary objectForKey:@"type"];

NSString *theValuePropertyList = [NSString stringWithFormat:@"<plist version=\"1.0\"><dict><key>value</key><%@>%@</%@></dict></plist>", theType, theStringValue, theType];

NSString *theErrorString = NULL;
NSDictionary *theValueDictionary = [NSPropertyListSerialization propertyListFromData:[theValuePropertyList dataUsingEncoding:NSUTF8StringEncoding] mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&theErrorString];

id theValue = [theValueDictionary objectForKey:@"value"];
if (theValue)
	{
	[self.store setObject:theValue forKey:theKey];
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)@"0");
	}
else
	{
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"Internal Error", kCFHTTPVersion1_0);

	NSData *theBodyData = [@"500 Internal Error" dataUsingEncoding:NSUTF8StringEncoding];
	CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);
	}

return(theResponse);
}

- (CFHTTPMessageRef)keyDeleterResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (outError)

CFHTTPMessageRef theResponse = NULL;
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(inRequest) autorelease];
NSString *theKey = [theURL.path.pathComponents objectAtIndex:2];

if ([self.store objectForKey:theKey])
	{
	[self.store removeObjectForKey:theKey];
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)@"0");
	}
else
	{
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"Internal Error", kCFHTTPVersion1_0);

	NSData *theBodyData = [@"500 Internal Error" dataUsingEncoding:NSUTF8StringEncoding];
	CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
	CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);
	}

return(theResponse);
}



@end
