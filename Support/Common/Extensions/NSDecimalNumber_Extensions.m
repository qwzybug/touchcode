//
//  NSDecimalNumber_Extensions.m
//  Touchcode
//
//  Created by Jonathan Wight on 08/19/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import "NSDecimalNumber_Extensions.h"


@implementation NSDecimalNumber (NSDecimalNumber_Extensions)

+ (id)decimalNumberWithObject:(id)inObject;
{
if ([inObject isKindOfClass:[NSString class]])
	{
	return([[[self alloc] initWithString:inObject] autorelease]);
	}
else if ([inObject isKindOfClass:[NSNumber class]])
	{
	return([[[self alloc] initWithString:[inObject stringValue]] autorelease]);
	}
else
	{
	return(NULL);
	}
}

@end
