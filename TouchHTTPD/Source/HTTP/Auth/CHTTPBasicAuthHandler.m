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
@synthesize realm;

- (id)init
{
if ((self = [super init]) != nil)
	{
	self.realm = @"Default Realm";
	}
return(self);
}

- (void)dealloc
{
self.childHandler = NULL;
self.delegate = NULL;
self.realm = NULL;
//
[super dealloc];
}


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
	
CHTTPMessage *theResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:401 bodyString:@"Unauthorized"];
[theResponse setHeader:[NSString stringWithFormat:@"Basic realm=\"%@\"", self.realm] forKey:@"WWW-Authenticate"];

*outResponse = theResponse;
*outError = NULL;
return(YES);
}

@end
