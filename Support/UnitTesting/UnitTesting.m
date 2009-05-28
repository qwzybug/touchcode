//
//  UnitTesting.m
//  TouchCode
//
//  Created by  on 20090528.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import <Foundation/Foundation.h>

#import "NSDate_InternetDateExtensions.h"
#import "NSDateFormatter_InternetDateExtensions.h"
#import "CMultiPickerDateFormatter.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

NSDate *theDate = [NSDate date];


for (NSDateFormatter *theFormatter in [NSDateFormatter allISO8601DateFormatters])
	{
	NSLog(@"%@", [theFormatter stringFromDate:theDate]);
	}


CMultiPickerDateFormatter *theFormatter = [[[CMultiPickerDateFormatter alloc] initWithFormatters:[NSDateFormatter allISO8601DateFormatters]] autorelease];

NSLog(@"%@", [theFormatter dateFromString:@"20010517T134339-0400"]);
NSLog(@"%@", [theFormatter.formatters valueForKey:@"dateFormat"]);

[pool drain];
return 0;
}
