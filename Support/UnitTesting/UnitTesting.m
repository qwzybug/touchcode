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
