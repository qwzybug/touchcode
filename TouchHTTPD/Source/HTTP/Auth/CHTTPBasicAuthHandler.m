//
//  CHTTPBasicAuthHandler.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/07/08.
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
