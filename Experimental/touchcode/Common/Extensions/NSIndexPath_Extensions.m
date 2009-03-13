//
//  NSIndexPath_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/23/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "NSIndexPath_Extensions.h"

@implementation NSIndexPath (NSIndexPath_Extensions)

+ (id)indexPathWithString:(NSString *)inString
{
NSIndexPath *theIndexPath = [[[NSIndexPath alloc] init] autorelease];

NSArray *theComponents = [inString componentsSeparatedByString:@","];
for (NSString *theComponent in theComponents)
	{
	theIndexPath = [theIndexPath indexPathByAddingIndex:[theComponent integerValue]];
	}

return(theIndexPath);
}

- (NSString *)stringValue
{
NSMutableArray *theComponents = [NSMutableArray arrayWithCapacity:[self length]];

for (NSUInteger N = 0; N != [self length]; ++N)
	{
	[theComponents addObject:[NSString stringWithFormat:@"%d", [self indexAtPosition:N]]];
	}

return([theComponents componentsJoinedByString:@","]);
}

@end
