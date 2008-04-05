//
//  CSampleHTTPHandler.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CSampleHTTPHandler.h"

#import "CRoutingHTTPConnection.h"

#import "CQTCaptureSnapshot.h"

@implementation CSampleHTTPHandler

- (id) init
{
if ((self = [super init]) != NULL)
	{
	snapshot = [[CQTCaptureSnapshot alloc] init];
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
#pragma unused (inConnection, inRequest, outTarget, outSelector, outError)
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(inRequest) autorelease];

*outTarget = self;


if ([[theURL path] isEqualToString:@"/favicon.ico"])
	*outSelector = @selector(favIconResponseForRequest:error:);
else// if ([[theURL path] isEqualToString:@"/webcam.jpg"])
	*outSelector = @selector(webcamResponseForRequest:error:);
//else
//	*outSelector = @selector(defaultResponseForRequest:error:);

return(YES);
}

- (CFHTTPMessageRef)defaultResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CFHTTPMessageRef theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

NSString *theBody = @"Hello World";
NSData *theBodyData = [theBody dataUsingEncoding:NSUTF8StringEncoding];
CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);

return(theResponse);
}

- (CFHTTPMessageRef)favIconResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CFHTTPMessageRef theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);

NSData *theBodyData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:@"/Users/schwa/Pictures/Icons/schwa.png"]];
CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"image/png");
CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);

return(theResponse);
}

- (CFHTTPMessageRef)webcamResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CFHTTPMessageRef theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, (CFStringRef)@"OK", kCFHTTPVersion1_0);



NSData *theBodyData = snapshot.jpegData;
CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"image/jpeg");
CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);

return(theResponse);
}

@end
