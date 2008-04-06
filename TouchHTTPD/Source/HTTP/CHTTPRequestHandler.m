//
//  CHTTPRequestHandler.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPRequestHandler.h"

@implementation CHTTPRequestHandler

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)outResponse error:(NSError **)outError
{
#pragma unused (inRequest, inConnection, outResponse, outError)
return(NO);
}

@end
