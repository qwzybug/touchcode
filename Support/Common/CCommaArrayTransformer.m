//
//  CCommaArrayTransform.m
//  WebServiceEngine
//
//  Created by brandon on 5/5/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "CCommaArrayTransformer.h"


@implementation CCommaArrayTransformer

+ (BOOL)allowsReverseTransformation
{
	return(NO);
}

- (id)transformedValue:(id)value
{
	NSAssert([value isKindOfClass:[NSArray class]], @"CCommaArrayTransform: value must be an NSArray!");
		
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	NSArray *array = value;
	for (NSObject *item in array)
	{
		if ([array objectAtIndex:0] == item)
			[result appendString:[item description]];
		else
			[result appendFormat:@",%@", [item description]];
	}
	return(result);
}

@end
