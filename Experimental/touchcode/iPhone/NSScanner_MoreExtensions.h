//
//  NSScanner_MoreExtensions.h
//  PettySVG
//
//  Created by Jonathan Wight on 12/27/2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @category NSScanner (NSScanner_MoreExtensions)
 * @abstract TODO
 * @discussion TODO
 */
@interface NSScanner (NSScanner_MoreExtensions)

- (NSString *)remainingString;

- (BOOL)scanAtMost:(NSInteger)inMaximum commaSeparatedDoubles:(NSArray **)outDoubles;

- (BOOL)skipComma;

- (BOOL)scanCGPoint:(CGPoint *)outCGPoint;

- (BOOL)scanCGFloat:(CGFloat *)outCGFloat;

- (BOOL)scanAtMost:(unsigned)N charactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;

- (BOOL)scanStringWithinParentheses:(NSString **)outString;

- (BOOL)scanNumber:(NSNumber **)outNumber;

- (BOOL)scanAtMost:(unsigned)N charactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;

- (BOOL)scanStringWithinParentheses:(NSString **)outString;

@end
