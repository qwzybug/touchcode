//
//  NSString_SqlExtensions.m
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import "NSString_SqlExtensions.h"

@implementation NSString (NSString_SqlExtensions)

- (NSString *)encodedForSql
{
NSMutableString *theString = [NSMutableString stringWithString:self];
//
[theString replaceOccurrencesOfString:@"'" withString:@"''" options:NSLiteralSearch range:NSMakeRange(0, [theString length])];
//
return(theString);
}

@end
