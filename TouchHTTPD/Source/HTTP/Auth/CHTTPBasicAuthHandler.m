//
//  CHTTPBasicAuthHandler.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPBasicAuthHandler.h"

#import "CHTTPMessage_ConvenienceExtensions.h"
#import "Base64Transcoder.h"

@implementation CHTTPBasicAuthHandler

@synthesize childHandler;
@synthesize delegate;

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)outResponse error:(NSError **)outError
{
NSString *theAuthorizationHeader = [inRequest headerForKey:@"Authorization"];
if (theAuthorizationHeader)
	{
	NSScanner *theScanner = [NSScanner scannerWithString:theAuthorizationHeader];
	if ([theScanner scanString:@"Basic" intoString:NULL] == YES)
		{
		NSCharacterSet *theBase64Characters = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="];
		NSString *theString = NULL;
		if ([theScanner scanCharactersFromSet:theBase64Characters intoString:&theString])
			{
			size_t theBufferSize = EstimateBas64DecodedDataSize([theString length]);
			NSMutableData *theBuffer = [NSMutableData dataWithLength:theBufferSize];
			BOOL theResult = Base64DecodeData([theString UTF8String], [theString length], [theBuffer mutableBytes], &theBufferSize);
			if (theResult == YES)
				{
				[theBuffer setLength:theBufferSize];
				
				if ([self.delegate HTTPAuthHandler:self shouldAuthenticateCredentials:theBuffer] == YES)
					{
					return([self.childHandler handleRequest:inRequest forConnection:inConnection response:outResponse error:outError]);
					}
				}
			}
		}
	}
	

if ([theAuthorizationHeader isEqualToString:@"Basic Zm9vOmZvbw=="] == NO)
	{
	CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:401 bodyString:@"Unauthorized"];
	[theResponse setHeader:@"Basic realm=\"Test Realm\"" forKey:@"WWW-Authenticate"];

	*outResponse = theResponse;
	*outError = NULL;
	return(YES);
	}
return(YES);
}

@end
