//
//  NSArray_SqlExtensions.h
//  Prototype
//
//  Created by Jonathan Wight on Fri Apr 16 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArray_SqlExtensions)

/**
 * @method componentsJoinedByQuotedSQLEscapedCommas
 */
- (NSString *)componentsJoinedByQuotedSQLEscapedCommas;

@end
