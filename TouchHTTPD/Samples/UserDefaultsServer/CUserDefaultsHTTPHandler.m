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

- (BOOL)routeConnection:(CRoutingHTTPConnection *)inConnection request:(CFHTTPMessageRef)inRequest toTarget:(id *)outTarget selector:(SEL *)outSelector error:(NSError **)outError;
{
#pragma unused (inConnection, outError)
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(inRequest) autorelease];
NSString *theMethod = [(NSString *)CFHTTPMessageCopyRequestMethod(inRequest) autorelease];

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

- (CFHTTPMessageRef)defaultResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CFHTTPMessageRef theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

NSString *theErrorDescription = NULL;
NSData *theBodyData = [NSPropertyListSerialization dataFromPropertyList:self.store format:NSPropertyListXMLFormat_v1_0 errorDescription:&theErrorDescription];
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
NSString *theKey = [[theURL.path.pathComponents objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSLog(@"%@", theKey);
NSString *theValue = [self.store objectForKey:theKey];
if (theValue)
	{
	theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

	NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		theValue, @"value",
		NULL];

	NSString *theErrorDescription = NULL;
	NSData *theBodyData = [NSPropertyListSerialization dataFromPropertyList:theDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&theErrorDescription];

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
NSString *theKey = [[theURL.path.pathComponents objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSLog(@"%@", theKey);

NSData *theBodyData = [(NSData *)CFHTTPMessageCopyBody(inRequest) autorelease];
NSString *theErrorString = NULL;
NSDictionary *theDictionary = [NSPropertyListSerialization propertyListFromData:theBodyData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&theErrorString];

id theValue = [theDictionary objectForKey:@"value"];

if (theValue)
	{
	[self.store setObject:theValue forKey:theKey];
	[self save];
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
NSString *theKey = [[theURL.path.pathComponents objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSLog(@"%@", theKey);

if ([self.store objectForKey:theKey])
	{
	[self.store removeObjectForKey:theKey];
	[self save];
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
