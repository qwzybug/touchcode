//
//  CHTTPMessage.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPMessage.h"

@implementation CHTTPMessage

@synthesize message;

+ (CHTTPMessage *)HTTPMessageRequest
{
CHTTPMessage *theHTTPMessage = [[[self alloc] init] autorelease];
theHTTPMessage.message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, YES);
return(theHTTPMessage);
}

+ (CHTTPMessage *)HTTPMessageResponseWithStatusCode:(NSInteger)inStatusCode statusDescription:(NSString *)inStatusDescription httpVersion:(NSString *)inHTTPVersion;
{
CHTTPMessage *theHTTPMessage = [[[self alloc] init] autorelease];
theHTTPMessage.message = CFHTTPMessageCreateResponse(kCFAllocatorDefault, inStatusCode, (CFStringRef)inStatusDescription, (CFStringRef)inHTTPVersion);
return(theHTTPMessage);
}

- (NSString *)requestMethod
{
NSString *theMethod = [(NSString *)CFHTTPMessageCopyRequestMethod(self.message) autorelease];
return(theMethod);
}

- (NSURL *)requestURL
{
NSURL *theURL = [(NSURL *)CFHTTPMessageCopyRequestURL(self.message) autorelease];
return(theURL);
}

- (void)appendData:(NSData *)inData;
{
BOOL theResult = CFHTTPMessageAppendBytes(self.message, inData.bytes, inData.length);
if (theResult == NO)
	{
	[NSException raise:NSGenericException format:@"HTTP ERROR"];
	}
}

- (BOOL)isHeaderComplete
{
return(CFHTTPMessageIsHeaderComplete(self.message));
}

- (NSString *)headerForKey:(NSString *)inKey
{
return([(NSString *)CFHTTPMessageCopyHeaderFieldValue(self.message, (CFStringRef)inKey) autorelease]);
}

- (void)setHeader:(NSString *)inHeader forKey:(NSString *)inKey
{
CFHTTPMessageSetHeaderFieldValue(self.message, (CFStringRef)inKey, (CFStringRef)inHeader);
}

- (NSData *)body
{
NSData *theBody = [(NSData *)CFHTTPMessageCopyBody(self.message) autorelease];
return(theBody);
}

- (void)setBody:(NSData *)inBody
{
CFHTTPMessageSetBody(self.message, (CFDataRef)inBody);
}

- (void)setContentType:(NSString *)inContentType body:(NSData *)inBody
{
[self setHeader:inContentType forKey:@"Content-Type"];
[self setHeader:[[NSNumber numberWithInteger:inBody.length] stringValue] forKey:@"Content-Length"];
[self setBody:inBody];
}

- (NSData *)serializedMessage
{
NSData *theData = [(NSData *)CFHTTPMessageCopySerializedMessage(self.message) autorelease];
return(theData);
}

@end
