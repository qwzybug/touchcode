//
//  NSData_Base64Extensions.m
//
//  Created by Jonathan Wight on 5/10/06.
//  Copyright (c) 2006 Toxic Software. All rights reserved.
//

#import "NSData_Base64Extensions.h"

#import "Base64Transcoder.h"

@implementation NSData (NSData_Base64Extensions)

+ (id)dataWithBase64EncodedString:(NSString *)inString;
{
NSData *theEncodedData = [inString dataUsingEncoding:NSASCIIStringEncoding];
size_t theDecodedDataSize = EstimateBas64DecodedDataSize([theEncodedData length]);
void *theDecodedData = malloc(theDecodedDataSize);
Base64DecodeData([theEncodedData bytes], [theEncodedData length], theDecodedData, &theDecodedDataSize);
theDecodedData = reallocf(theDecodedData, theDecodedDataSize);
if (theDecodedData == NULL)
	return(NULL);
id theData = [self dataWithBytesNoCopy:theDecodedData length:theDecodedDataSize freeWhenDone:YES];
return(theData);
}

- (NSString *)asBase64EncodedString;
{
size_t theEncodedDataSize = EstimateBas64EncodedDataSize([self length]);
void *theEncodedData = malloc(theEncodedDataSize);
Base64EncodeData([self bytes], [self length], theEncodedData, &theEncodedDataSize);
theEncodedData = reallocf(theEncodedData, theEncodedDataSize);
if (theEncodedData == NULL)
	return(NULL);
id theData = [NSData dataWithBytesNoCopy:theEncodedData length:theEncodedDataSize freeWhenDone:YES];
return([[[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding] autorelease]);
}

@end
