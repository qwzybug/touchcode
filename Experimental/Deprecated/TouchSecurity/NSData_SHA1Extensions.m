//
//  NSData_SHA1Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/30/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSData_SHA1Extensions.h"

#include "sha1.h"

@implementation NSData (NSData_SHA1Extensions)

- (NSData *)SHA1Hash
{
SHA1_CTX theContext;
SHA1Init(&theContext);
SHA1Update(&theContext, [self bytes], [self length]);
unsigned char digest[20];
SHA1Final(digest, &theContext);
NSData *theSHA1Hash = [NSData dataWithBytes:digest length:20];
return(theSHA1Hash);
}

@end
