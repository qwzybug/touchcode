//
//  NSString_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSString_Extensions.h"

#import "NSScanner_HTMLExtensions.h"

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

@end
