//
//  CHumanDateFormatter.m
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHumanDateFormatter.h"

static NSDateFormatter *gSubDateFormatter1 = NULL;
static NSDateFormatter *gSubDateFormatter2 = NULL;
static NSDateFormatter *gSubDateFormatter3 = NULL;
static NSDateFormatter *gSubDateFormatter4 = NULL;

@implementation CHumanDateFormatter

@synthesize singleLine;
@synthesize relative;

// TODO one way to speed this up is to pre-init all the subDateFormatter objects (as statics).

+ (id)humanDateFormatter:(BOOL)inSingleLine
{
static CHumanDateFormatter *theSingleLineFormatter = NULL;
static CHumanDateFormatter *theMultiLineFormatter = NULL;
if (inSingleLine == YES)
	{
	if (theSingleLineFormatter == NULL)
		{
		theSingleLineFormatter = [[self alloc] init];
		theSingleLineFormatter.singleLine = inSingleLine;
		}
	return(theSingleLineFormatter);
	}
else
	{
	if (theMultiLineFormatter == NULL)
		{
		theMultiLineFormatter = [[self alloc] init];
		theMultiLineFormatter.singleLine = inSingleLine;
		}
	return(theMultiLineFormatter);
	}
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	@synchronized([self class])
		{
		if (gSubDateFormatter1 == NULL)
			{
			NSDateFormatter *theSubDateFormatter = NULL;
			
			// ############################################

			theSubDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theSubDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theSubDateFormatter setDateStyle:NSDateFormatterNoStyle];
			[theSubDateFormatter setTimeStyle:NSDateFormatterShortStyle];
			
			gSubDateFormatter1 = [theSubDateFormatter retain];

			// ############################################
			
			theSubDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theSubDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theSubDateFormatter setDateStyle:NSDateFormatterNoStyle];
			[theSubDateFormatter setTimeStyle:NSDateFormatterShortStyle];

			gSubDateFormatter2 = [theSubDateFormatter retain];

			// ############################################

			theSubDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theSubDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theSubDateFormatter setDateStyle:NSDateFormatterNoStyle];
			[theSubDateFormatter setTimeStyle:NSDateFormatterShortStyle];

			gSubDateFormatter3 = [theSubDateFormatter retain];

			// ############################################

			theSubDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[theSubDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
			[theSubDateFormatter setDateStyle:NSDateFormatterShortStyle];
			[theSubDateFormatter setTimeStyle:NSDateFormatterNoStyle];

			gSubDateFormatter4 = [theSubDateFormatter retain];

			// ############################################
			}
		}
	}
return(self);
}

- (NSString *)stringFromDate:(NSDate *)inDate
{
NSDateComponents *theDateComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit fromDate:inDate];
//
NSDate *theNow = [NSDate date];

// #############################################################################

NSDateComponents *theTodayComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit fromDate:theNow];

if ([theDateComponents isEqual:theTodayComponents])
	{
	if (self.singleLine == YES)
		return(@"Today");
	else
		return([NSString stringWithFormat:@"Today\n%@", [gSubDateFormatter1 stringFromDate:inDate]]);
	}

// #############################################################################

NSDateComponents *theDelta = [[[NSDateComponents alloc] init] autorelease];
[theDelta setDay:+1];
NSDate *theTomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:theDelta toDate:theNow options:NSWrapCalendarComponents];
NSDateComponents *theTomorrowComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit fromDate:theTomorrow];

if ([theDateComponents isEqual:theTomorrowComponents])
	{
	if (self.singleLine == YES)
		return(@"Tomorrow");
	else
		return([NSString stringWithFormat:@"Tomorrow\n%@", [gSubDateFormatter2 stringFromDate:inDate]]);
	}

// #############################################################################

[theDelta setDay:-1];
NSDate *theYesterday = [[NSCalendar currentCalendar] dateByAddingComponents:theDelta toDate:theNow options:NSWrapCalendarComponents];
NSDateComponents *theYesterdayComponents = [[NSCalendar currentCalendar] components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit fromDate:theYesterday];

if ([theDateComponents isEqual:theYesterdayComponents])
	{
	if (self.singleLine == YES)
		return(@"Yesterday");
	else
		return([NSString stringWithFormat:@"Yesterday\n%@", [gSubDateFormatter3 stringFromDate:inDate]]);
	}

if (self.relative == YES) {
	int days = (int) ceil([theNow timeIntervalSinceDate:inDate] / (60 * 60 * 24));
	return [NSString stringWithFormat:@"%d days ago",days];
}
	
if ([theNow timeIntervalSinceDate:inDate] < 7 * 24 * 60 * 60)
	{
	NSDateFormatter *theSubDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[theSubDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	if (self.singleLine == YES)
		[theSubDateFormatter setDateStyle:NSDateFormatterShortStyle];
	else
		[theSubDateFormatter setDateFormat:@"EEEE\nh:mm a"];
	//
	return([NSString stringWithFormat:@"%@", [theSubDateFormatter stringFromDate:inDate]]);
	}

// #############################################################################
//
return([gSubDateFormatter4 stringFromDate:inDate]);
}

@end
