//
//  NSValue_Extensions.m
//  MapToy
//
//  Created by Jonathan Wight on 04/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSValue_Extensions.h"


@implementation NSValue (NSValue_Extensions)

+ (NSValue *)valueWithCGPoint:(CGPoint)inPoint
{
return([NSValue valueWithBytes:&inPoint objCType:@encode(CGPoint)]);
}

- (CGPoint)CGPointValue
{
CGPoint theValue;
[self getValue:&theValue];
return(theValue);
}

+ (NSValue *)valueWithCGSize:(CGSize)inSize
{
return([NSValue valueWithBytes:&inSize objCType:@encode(CGSize)]);
}

- (CGSize)CGSizeValue
{
CGSize theValue;
[self getValue:&theValue];
return(theValue);
}

+ (NSValue *)valueWithCGRect:(CGRect)inRect
{
return([NSValue valueWithBytes:&inRect objCType:@encode(CGRect)]);
}

- (CGRect)CGRectValue
{
CGRect theValue;
[self getValue:&theValue];
return(theValue);
}

@end
