//
//  NSArray_SqlExtensions.m
//  Prototype
//
//  Created by Jonathan Wight on Fri Apr 16 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "NSArray_SqlExtensions.h"

@implementation NSArray (NSArray_Extensions)

- (NSString *)componentsJoinedByQuotedSQLEscapedCommas
{
// ### Note I'm doing a certain amount of optimisation here which is why the code is a little bit fuggly (e.g. I'm avoiding NSEnumerators and trying not to create too many temporary objects).
NSMutableString *theString = [NSMutableString stringWithCapacity:512];
unsigned theCount = [self count];
//
for (unsigned N = 0; N != theCount; ++N)
	{
	id theObject = [self objectAtIndex:N];
	if (theObject == NULL || [theObject isEqual:[NSNull null]])
		{
		[theString appendString:@"null"];
		}
	else
		{
		NSString *theTrimmedString = [theObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ([theTrimmedString length] == 0)
			{
			[theString appendString:@"null"];
			}
		else
			{
			[theString appendString:@"'"];
			unsigned theStringLength = [theString length];
			[theString appendString:theTrimmedString];
			[theString replaceOccurrencesOfString:@"\'" withString:@"\'\'" options:NSLiteralSearch range:NSMakeRange(theStringLength, [theTrimmedString length])];
			[theString appendString:@"'"];
			}
		}
	if (N != theCount - 1)
		[theString appendString:@", "];
	}
return(theString);
}

@end
