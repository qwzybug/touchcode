//
//  NSString_SqlExtensions.h
//  sqllitetest
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright (c) 2004 Toxic Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_SqlExtensions)

- (NSString *)encodedForLike;
- (NSString *)encodedForSql;

@end
