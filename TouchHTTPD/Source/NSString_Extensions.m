//
//  NSString_Extensions.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSString_Extensions.h"

@implementation NSString (NSString_Extensions)

- (NSString *)stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:(NSString *)inCharactersToLeaveUnescaped legalURLCharactersToBeEscaped:(NSString *)inLegalURLCharactersToBeEscaped usingEncoding:(NSStringEncoding)inEncoding
{
NSString *theEscapedString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)inCharactersToLeaveUnescaped, (CFStringRef)inLegalURLCharactersToBeEscaped, (CFStringEncoding)inEncoding) autorelease];

return(theEscapedString);
}

- (NSString *)stringByObsessivelyAddingPercentEscapesUsingEncoding:(NSStringEncoding)inEncoding
{
return([self stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:@"abcdefghijklmnopqrstuvwyxzABCDEFGHIJKLMNOPQRSTUVWXYZ123456780" legalURLCharactersToBeEscaped:@"/=&?" usingEncoding:inEncoding]);
}

@end
