//
//  CRoutingHTTPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CRoutingHTTPConnection.h"

@implementation CRoutingHTTPConnection

@synthesize router;

- (void)requestReceived:(CFHTTPMessageRef)inRequest
{
NSError *theError = NULL;

id theTarget = NULL;
SEL theSelector = NULL;

BOOL theResult = [self.router routeConnection:self request:inRequest toTarget:&theTarget selector:&theSelector error:&theError];

if (theResult == NO)
	{
	theTarget = self;
	theSelector = @selector(errorNotFoundResponseForRequest:error:);
	}

NSError **theErrorArgument = &theError;

NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[theTarget methodSignatureForSelector:theSelector]];
[theInvocation setSelector:theSelector];
[theInvocation setTarget:theTarget];
[theInvocation setArgument:&inRequest atIndex:2];
[theInvocation setArgument:&theErrorArgument atIndex:2];

[theInvocation invoke];

CFHTTPMessageRef theResponse = NULL;

[theInvocation getReturnValue:&theResponse];

[self sendResponse:theResponse];

CFRelease(theResponse);
}

- (SEL)selectorForRequest:(CFHTTPMessageRef)inRequest
{
#pragma unused (inRequest, NULL)
return(NULL);
}

- (CFHTTPMessageRef)errorNotFoundResponseForRequest:(CFHTTPMessageRef)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CFHTTPMessageRef theResponse = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 404, (CFStringRef)@"NOT FOUND", kCFHTTPVersion1_0);

NSString *theBody = @"404 NOT FOUND";
NSData *theBodyData = [theBody dataUsingEncoding:NSUTF8StringEncoding];
CFHTTPMessageSetBody(theResponse, (CFDataRef)theBodyData);

CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
CFHTTPMessageSetHeaderFieldValue(theResponse, (CFStringRef)@"Content-Length", (CFStringRef)[[NSNumber numberWithInteger:theBodyData.length] stringValue]);

return(theResponse);
}

@end
