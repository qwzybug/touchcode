//
//  NSDate_ISO8601Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 06/05/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSDate_ISO8601Extensions.h"

@implementation NSDate (NSDate_ISO8601Extensions)

static NSDateFormatter *gDateFormatter = NULL;

- (NSString *)IS08601StringValue
{
@synchronized([self class])
	{
	if (gDateFormatter == NULL)
		{
		const NSDateFormatterBehavior theOldBehavior = [NSDateFormatter defaultFormatterBehavior];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[theFormatter setDateFormat:@"yyyyy-MM-dd'T'hh:mm'Z'"];
		[NSDateFormatter setDefaultFormatterBehavior:theOldBehavior];
		
		gDateFormatter = [theFormatter retain];
		}
	}
NSString *theDateString = [gDateFormatter stringFromDate:self];
return(theDateString);
}

@end
