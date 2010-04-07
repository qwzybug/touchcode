//
//  NSURL_DataExtensions.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/07/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSURL_DataExtensions.h"

#import "NSData_Base64Extensions.h"
#import "Base64Transcoder.h"

@implementation NSURL (NSURL_DataExtensions)

+ (NSURL *)dataURLWithData:(NSData *)inData mimeType:(NSString *)inMimeType charset:(NSString *)inCharset
{
NSString *theEncodedData = [inData asBase64EncodedString:0];

NSString *theString = [NSString stringWithFormat:@"data:%@;%@base64,%@",
	inMimeType,
	inCharset ? [NSString stringWithFormat:@"charset=\"%@\";", inCharset] : @"",
	theEncodedData];

NSURL *theURL = [NSURL URLWithString:theString];
return(theURL);
}

@end
