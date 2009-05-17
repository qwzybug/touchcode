//
//  NSDateFormatter_InternetDateExtensions.h
//  UnitTesting
//
//  Created by Jonathan Wight on 5/16/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (NSDateFormatter_InternetDateExtensions)

+ (NSDateFormatter *)RFC2822Formatter;
+ (NSDateFormatter *)ISO8601Formatter;

+ (NSArray *)allRFC2822DateFormatters;
+ (NSArray *)allISO8601DateFormatters;

+ (NSArray *)allInternetDateFormatters;

@end
