//
//  NSString_Extensions.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Extensions)

- (NSString *)stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:(NSString *)inCharactersToLeaveUnescaped legalURLCharactersToBeEscaped:(NSString *)inLegalURLCharactersToBeEscaped usingEncoding:(NSStringEncoding)inEncoding;

- (NSString *)stringByObsessivelyAddingPercentEscapesUsingEncoding:(NSStringEncoding)inEncoding;

@end
