//
//  CHTTPMessage.m
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
