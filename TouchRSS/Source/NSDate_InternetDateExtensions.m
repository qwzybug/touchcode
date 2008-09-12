//
//  NSDate_InternetDateExtensions.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright (c) 2008 Jonathan Wight
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSDate_InternetDateExtensions.h"

@implementation NSDate (NSDate_InternetDateExtensions)

+ (NSDate *)dateWithRFC1822String:(NSString *)inString
{
static NSArray *sFormatters = NULL;
@synchronized([self class])
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
