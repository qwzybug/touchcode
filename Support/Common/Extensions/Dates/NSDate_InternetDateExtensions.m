//
//  NSDate_InternetDateExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import "NSDateFormatter_InternetDateExtensions.h"

@implementation NSDate (NSDate_InternetDateExtensions)

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
NSDate *theDate = [NSDate date];
NSLog(@"%@", [theDate RFC822String]);
NSLog(@"%@", [[theDate UTCDate] RFC822String]);
//
[thePool release];
}

- (NSData *)UTCDate
{
NSCalendar *theCalendar = [[[NSCalendar currentCalendar] copy] autorelease];
NSDateComponents *theComponents = [theCalendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
theCalendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
return([theCalendar dateFromComponents:theComponents]);
}

+ (NSDate *)dateWithRFC2822String:(NSString *)inString
{
NSDate *theDate = [[NSDateFormatter RFC2822Formatter] dateFromString:inString];
return(theDate);
}

- (NSString *)RFC822String
{
NSString *theDateString = [[NSDateFormatter RFC2822Formatter] stringFromDate:self];
return(theDateString);
}

- (NSString *)RFC822StringGMT
{
NSString *theDateString = [[NSDateFormatter RFC2822FormatterGMT] stringFromDate:self];
return(theDateString);
}

- (NSString *)RFC822StringUTC
{
NSString *theDateString = [[NSDateFormatter RFC2822FormatterUTC] stringFromDate:self];
return(theDateString);
}

+ (NSDate *)dateWithISO8601String:(NSString *)inString
{
NSDate *theDate = NULL;
for (NSDateFormatter *theDateFormatter in [NSDateFormatter allISO8601DateFormatters])
	{
	theDate = [theDateFormatter dateFromString:inString];
	if (theDate != NULL)
		break;
	}

NSAssert1(theDate != NULL, @"Could not convert ISO8601 date string of \"%@\" to a NSDate", inString);

return(theDate);
}

- (NSString *)ISO8601String
{
NSString *theDateString = [[NSDateFormatter ISO8601Formatter] stringFromDate:self];
return(theDateString);
}

- (NSString *)ISO8601MinimalString
{
NSString *theDateString = [[NSDateFormatter ISO8601FormatterMinimal] stringFromDate:self];
return(theDateString);
}


@end
