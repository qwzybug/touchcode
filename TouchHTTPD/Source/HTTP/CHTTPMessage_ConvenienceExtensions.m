//
//  CHTTPMessage_ConvenienceExtensions.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHTTPMessage_ConvenienceExtensions.h"

@implementation CHTTPMessage (CHTTPMessage_ConvenienceExtensions)

+ (CHTTPMessage *)HTTPMessageResponseWithStatusCode:(NSInteger)inStatusCode bodyString:(NSString *)inBodyString
{
CHTTPMessage *theHTTPMessage = [self HTTPMessageResponseWithStatusCode:inStatusCode statusDescription:@"WHOOPS" httpVersion:kHTTPVersion1_0];

[theHTTPMessage setContentType:@"text/plain" body:[inBodyString dataUsingEncoding:NSUTF8StringEncoding]];

return(theHTTPMessage);
}

@end
