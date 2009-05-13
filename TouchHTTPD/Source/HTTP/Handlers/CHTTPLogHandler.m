//
//  CHTTPLogHandler.m
//  FileServer
//
//  Created by Jonathan Wight on 1/2/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CHTTPLogHandler.h"

#import "CHTTPMessage.h"

@implementation CHTTPLogHandler

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)ioResponse error:(NSError **)outError;
{
#pragma unused (inRequest, inConnection, outError)

CHTTPMessage *theResponse = *ioResponse;

printf("#### BEGIN HTTP REQUEST/RESPONSE ###################################\n");
printf("#### REQUEST HEADERS ####\n");
printf("%s\n", [[[[NSString alloc] initWithData:[inRequest headerData] encoding:NSUTF8StringEncoding] autorelease] UTF8String]);
printf("#### REQUEST BODY ####\n");
if ([inRequest bodyData])
	printf("%s\n", [[[[NSString alloc] initWithData:[inRequest bodyData] encoding:NSUTF8StringEncoding] autorelease] UTF8String]);
else
	{
	printf("%s\n", [[inRequest.body description] UTF8String]);
	}


printf("#### RESPONSE HEADERS ####\n");
printf("%s\n", [[[[NSString alloc] initWithData:[theResponse headerData] encoding:NSUTF8StringEncoding] autorelease] UTF8String]);
printf("#### RESPONSE BODY ####\n");
if ([theResponse bodyData])
	printf("%s\n", [[[[NSString alloc] initWithData:[theResponse bodyData] encoding:NSUTF8StringEncoding] autorelease] UTF8String]);
else
	{
	printf("%s\n", [[theResponse.body description] UTF8String]);
	}
printf("#### END HTTP REQUEST/RESPONSE #####################################\n");

return(YES);
}


@end
