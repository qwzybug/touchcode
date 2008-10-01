//
//  NSData_MD5Extensions.m
//  TouchCode
//
//  Created by Devin Chalmers on 7/6/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "NSData_MD5Extensions.h"

#include <CommonCrypto/CommonDigest.h>

@implementation NSData (NSData_MD5Extensions)

- (NSData *)MD5Hash
{
	CC_MD5_CTX theContext;
	CC_MD5_Init(&theContext);
	CC_MD5_Update(&theContext, [self bytes], [self length]);
	unsigned char digest[32];
	CC_MD5_Final(digest, &theContext);
	NSData *theMD5Hash = [NSData dataWithBytes:digest length:32];
	return(theMD5Hash);
}

@end
