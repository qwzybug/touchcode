//
//  NSDate_InternetDateExtensions.h
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSDate (NSDate_InternetDateExtensions)

+ (NSDate *)dateWithRFC1822String:(NSString *)inString;

@end
