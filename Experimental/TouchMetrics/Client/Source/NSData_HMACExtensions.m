//
//  NSData_HMACExtensions.m
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "NSData_HMACExtensions.h"

#include <CommonCrypto/CommonHMAC.h>`

@implementation NSData (NSData_HMACExtensions)

- (NSData *)HMACDigestWithKey:(NSData *)inKey
{
char theDigestBuffer[20];

CCHmac(kCCHmacAlgSHA1, [inKey bytes], [inKey length], [self bytes], [self length], theDigestBuffer);

NSData *theDigest = [NSData dataWithBytes:theDigestBuffer length:20];
return(theDigest);
}

@end
