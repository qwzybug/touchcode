//
//  CRoutingHTTPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CRoutingHTTPRequestHandler.h"

#import "CHTTPMessage.h"
#import "CHTTPMessage_ConvenienceExtensions.h"

@implementation CRoutingHTTPRequestHandler

@synthesize router;

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)outResponse error:(NSError **)outError
{
#pragma unused (inConnection, outError)
CHTTPMessage *theResponse = NULL;

@try
	{
	NSError *theError = NULL;

	id theTarget = NULL;
	SEL theSelector = NULL;

	BOOL theResult = [self.router routeConnection:self request:inRequest toTarget:&theTarget selector:&theSelector error:&theError];

	if (theResult == NO || theTarget == NULL || theSelector == NULL)
		{
		theTarget = self;
		theSelector = @selector(errorNotFoundResponseForRequest:error:);
		}

	NSError **theErrorArgument = &theError;

	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[theTarget methodSignatureForSelector:theSelector]];
	[theInvocation setSelector:theSelector];
	[theInvocation setTarget:theTarget];
	[theInvocation setArgument:&inRequest atIndex:2];
	[theInvocation setArgument:&theErrorArgument atIndex:3];

	[theInvocation invoke];

	[theInvocation getReturnValue:&theResponse];
	}
@catch (NSException *localException)
	{
	}

*outResponse = theResponse;
return(YES);
}

- (CHTTPMessage *)errorNotFoundResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:404 bodyString:@"404 NOT FOUND"];
return(theResponse);
}

@end
