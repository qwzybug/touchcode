//
//  CValueValidator.m
//  Birdfeed Redux
//
//  Created by Jonathan Wight on 03/30/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CValueValidator.h"


@implementation CValueValidator

+ (CValueValidator *)valueValidatorForName:(NSString *)name;
{
return((id)[self valueTransformerForName:name]);
}

+ (void)setValueValidator:(CValueValidator *)validator forName:(NSString *)name
{
[self setValueTransformer:validator forName:name];
}

+ (Class)transformedValueClass
{
return([NSNumber class]);
}

+ (BOOL)allowsReverseTransformation
{
return(NO);
}

- (id)transformedValue:(id)value
{
BOOL theIsValidFlag = [self isValid:value];
NSNumber *theIsValidValue = [NSNumber numberWithBool:theIsValidFlag];
return(theIsValidValue);
}

- (BOOL)isValid:(id)inValue
{
return([self validateValue:inValue error:NULL]);
}

- (BOOL)validateValue:(id)inValue error:(NSError **)outError;
{
return(YES);
}

@end
