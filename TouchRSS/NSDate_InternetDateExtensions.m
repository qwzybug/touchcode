//
//  NSDate_InternetDateExtensions.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSDate_InternetDateExtensions.h"

@implementation NSDate (NSDate_InternetDateExtensions)

+ (NSDate *)dateWithRFC1822String:(NSString *)inString
{
static NSArray *sFormatters = NULL;
@synchronized(self)
	{
	if (sFormatters == NULL)
		{
		NSMutableArray *theFormatters = [NSMutableArray array];
		NSDateFormatterBehavior theOldDateFormatterBehavior = [NSDateFormatter defaultFormatterBehavior];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *theFormatter = NULL;
		
		theFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[theFormatter setDateFormat:@"EEE, d MMM yy HH:mm:ss zzz"];
		[theFormatters addObject:theFormatter];

		theFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[theFormatter setDateFormat:@"d MMM yy HH:mm:ss zzz"];
		[theFormatters addObject:theFormatter];

		[NSDateFormatter setDefaultFormatterBehavior:theOldDateFormatterBehavior];
		
		sFormatters = [theFormatters copy];
		}
	}

for (NSDateFormatter *theFormatter in sFormatters)
	{
	NSDate *theDate = [theFormatter dateFromString:inString];
	if (theDate != NULL && [theDate timeIntervalSince1970] > 0.0)
		return(theDate);
	}
return(NULL);
}

/*
date-time       =       [ day-of-week "," ] date FWS time [CFWS]

day-of-week     =       ([FWS] day-name) / obs-day-of-week

day-name        =       "Mon" / "Tue" / "Wed" / "Thu" /
                        "Fri" / "Sat" / "Sun"

date            =       day month year

year            =       4*DIGIT / obs-year

month           =       (FWS month-name FWS) / obs-month

month-name      =       "Jan" / "Feb" / "Mar" / "Apr" /
                        "May" / "Jun" / "Jul" / "Aug" /
                        "Sep" / "Oct" / "Nov" / "Dec"

day             =       ([FWS] 1*2DIGIT) / obs-day

time            =       time-of-day FWS zone

time-of-day     =       hour ":" minute [ ":" second ]

hour            =       2DIGIT / obs-hour

minute          =       2DIGIT / obs-minute

second          =       2DIGIT / obs-second

zone            =       (( "+" / "-" ) 4DIGIT) / obs-zone
*/


@end
