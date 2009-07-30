//
//  NSOperation_DebugExtensions.h
//  LoggingTest
//
//  Created by Jonathan Wight on 7/29/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (NSOperation_DebugExtensions)

- (void)dump;
- (void)dump:(NSUInteger)inLevel;

@end
