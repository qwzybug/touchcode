//
//  NSDate_SqlExtension.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSDate_SqlExtension.h"

@implementation NSDate (NSDate_SqlExtension)

static NSDateFormatter *gDateFormatter = NULL;

- (NSString *)sqlDate
{
@synchronized([self class])
	{
// 2008-09-09 02:12:36
	if (gDateFormatter == NULL)
		{
		NSDateFormatter *theFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[theFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[theFormatter setGeneratesCalendarDates:NO];
		[theFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[theFormatter setDateFormat:@"yyyyy-MM-dd hh:mm"];
		
		gDateFormatter = [theFormatter retain];
		}
	}
NSString *theDateString = [gDateFormatter stringFromDate:self];
return(theDateString);
}


@end
