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
if ([value isKindOfClass:[NSNumber class]])
	{
	CFNumberRef theNumber = (CFNumberRef)value;
	CFNumberType theType = CFNumberGetType(theNumber);
	switch (theType)
		{
		case kCFNumberFloat32Type:
		case kCFNumberFloat64Type:
		case kCFNumberFloatType:
		case kCFNumberDoubleType:
		case kCFNumberCGFloatType:
			{
			double theDouble = [value doubleValue];
			return([NSString stringWithFormat:@"%f", theDouble]);
			}
			break;
		default:
			{
			return([value stringValue]);
			}
			break;
		}
	}
else
	{
	return(NULL);
	}
}


@end
