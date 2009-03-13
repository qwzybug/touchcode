//
//  NSString_MoreExtensions.m
//  PettySVG
//
//  Created by Jonathan Wight on 12/27/2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "NSString_MoreExtensions.h"

#import "NSScanner_Extensions.h"

@implementation NSString (NSString_MoreExtensions)
 
- (NSArray *)componentsSeperatedByWhitespaceRunsOrComma
{
NSMutableArray *theArray = [NSMutableArray array];
//
NSMutableCharacterSet *theCommaCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@","] mutableCopy];
[theCommaCharacterSet autorelease];
[theCommaCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSCharacterSet *theNonDelimiterCharacterSet = [theCommaCharacterSet invertedSet];
//
NSScanner *theScanner = [NSScanner scannerWithString:self];
while ([theScanner isAtEnd] == NO)
	{
	[theScanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
	[theScanner scanString:@"," intoString:NULL];
		
	NSString *theValue = NULL;
	if ([theScanner scanCharactersFromSet:theNonDelimiterCharacterSet intoString:&theValue] == YES)
		{
		[theArray addObject:theValue];
		}
	}
return(theArray);
}

#pragma mark -

- (long)asLongFromHex
{
long theValue = strtol([self UTF8String], NULL, 16);
return(theValue);
}

@end
