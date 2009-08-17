//
//  CNumberToStringValueTransformer.m
//  Touchcode
//
//  Created by Jonathan Wight on 8/17/09.
//  Copyright 2009 Touchcode. All rights reserved.
//

#import "CNumberToStringValueTransformer.h"


@implementation CNumberToStringValueTransformer

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
[self setValueTransformer:[[[self alloc] init] autorelease] forName:NSStringFromClass(self)];
//
[thePool release];
}

+ (Class)transformedValueClass
{
return([NSString class]);
}

+ (BOOL)allowsReverseTransformation
{
return(NO);
}

- (id)transformedValue:(id)value
{
double theDouble = [value doubleValue];
return([NSString stringWithFormat:@"%f", theDouble]);
}

/*
- (id)reverseTransformedValue:(id)value
{
return(<#some value#>;
}
*/

@end
