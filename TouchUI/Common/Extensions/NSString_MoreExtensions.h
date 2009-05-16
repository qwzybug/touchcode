//
//  NSString_MoreExtensions.h
//  PettySVG
//
//  Created by Jonathan Wight on 12/27/2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @category NSString (NSString_MoreExtensions)
 * @abstract TODO
 * @discussion TODO
 */
@interface NSString (NSString_MoreExtensions)

- (NSArray *)componentsSeperatedByWhitespaceRunsOrComma;

- (long)asLongFromHex;

@end
