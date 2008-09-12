//
//  NSDate_ISO8601Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 06/05/08.
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

#import "NSDate_ISO8601Extensions.h"

@implementation NSDate (NSDate_ISO8601Extensions)

static NSDateFormatter *gDateFormatter = NULL;

- (NSString *)ISO8601StringValue
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
