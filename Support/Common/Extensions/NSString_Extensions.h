//
//  NSString_Extensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Extensions)

- (NSString *)stringByTidyingHTMLEntities;

- (NSArray *)componentsSeperatedByWhitespaceRunsOrComma;

- (long)asLongFromHex;

- (NSString *)stringByAddingPercentEscapesWithCharactersToLeaveUnescaped:(NSString *)inCharactersToLeaveUnescaped legalURLCharactersToBeEscaped:(NSString *)inLegalURLCharactersToBeEscaped usingEncoding:(NSStringEncoding)inEncoding;

- (NSString *)stringByObsessivelyAddingPercentEscapesUsingEncoding:(NSStringEncoding)inEncoding;

@end
