//
//  NSString_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSString_Extensions.h"

#import "NSScanner_HTMLExtensions.h"
#import "NSScanner_Extensions.h"

@implementation NSString (NSString_Extensions)

- (NSString *)stringByTidyingHTMLEntities
{
NSMutableString *theOutput = [NSMutableString string];

NSScanner *theScanner = [NSScanner scannerWithString:self];
[theScanner setCharactersToBeSkipped:NULL];

while ([theScanner isAtEnd] == NO)
	{
	NSString *theString = NULL;
	if ([theScanner scanUpToString:@"&" intoString:&theString] == YES)
		{
		[theOutput appendString:theString];
		}
	if ([theScanner scanHTMLEntityIntoString:&theString] == YES)
		{
		[theOutput appendString:theString];
		}
	else
		{
		if ([theScanner scanString:@"&" intoString:&theString] == YES)
			{
			[theOutput appendString:theString];
			}
		}
	}

return([[theOutput copy] autorelease]);
}

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

- (NSString *)stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:(NSString *)inCharactersToLeaveUnescaped legalURLCharactersToBeEscaped:(NSString *)inLegalURLCharactersToBeEscaped usingEncoding:(NSStringEncoding)inEncoding
{
NSString *theEscapedString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)inCharactersToLeaveUnescaped, (CFStringRef)inLegalURLCharactersToBeEscaped, (CFStringEncoding)inEncoding) autorelease];

return(theEscapedString);
}

- (NSString *)stringByObsessivelyAddingPercentEscapesUsingEncoding:(NSStringEncoding)inEncoding
{
return([self stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:@"abcdefghijklmnopqrstuvwyxzABCDEFGHIJKLMNOPQRSTUVWXYZ123456780" legalURLCharactersToBeEscaped:@"/=&?" usingEncoding:inEncoding]);
}


@end
