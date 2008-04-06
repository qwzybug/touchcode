//
//  CBasicAuthHTTPHandler.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CBasicAuthHTTPRouter.h"

#import "CRoutingHTTPRequestHandler.h"
#import "CHTTPMessage.h"
#import "CHTTPMessage_ConvenienceExtensions.h"

@implementation CBasicAuthHTTPRouter

- (BOOL)routeConnection:(CRoutingHTTPRequestHandler *)inConnection request:(CHTTPMessage *)inRequest toTarget:(id *)outTarget selector:(SEL *)outSelector error:(NSError **)outError;
{
#pragma unused (inConnection, inRequest, outTarget, outSelector, outError)

*outTarget = self;

if ([inRequest headerForKey:@"Authorization"] == NULL)
	{
	*outSelector = @selector(unauthorizedResponseForRequest:error:);
	}
else
	{
	NSLog(@"%@", [inRequest headerForKey:@"Authorization"]);
	if ([[inRequest headerForKey:@"Authorization"] isEqualToString:@"Basic Zm9vOmZvbw=="])
		*outSelector = @selector(defaultResponseForRequest:error:);
	else
		*outSelector = @selector(unauthorizedResponseForRequest:error:);
	}

return(YES);
}

- (CHTTPMessage *)unauthorizedResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:401 bodyString:@"Unauthorized"];

[theResponse setHeader:@"Basic realm=\"Test Realm\"" forKey:@"WWW-Authenticate"];

return(theResponse);
}

- (CHTTPMessage *)defaultResponseForRequest:(CHTTPMessage *)inRequest error:(NSError **)outError
{
#pragma unused (inRequest, outError)
CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:200 bodyString:@"Hello World"];
return(theResponse);
}

@end
