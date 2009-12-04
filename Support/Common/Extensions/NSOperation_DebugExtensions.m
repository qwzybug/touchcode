//
//  NSOperation_DebugExtensions.m
//  LoggingTest
//
//  Created by Jonathan Wight on 7/29/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "NSOperation_DebugExtensions.h"

@implementation NSOperation (NSOperation_DebugExtensions)

- (void)dump
{
[self dump:0];
}

- (void)dump:(NSUInteger)inLevel
{
char theFiller[] = "*********************************";
printf("%.*s%s\n", (int)inLevel, theFiller, [[self description] UTF8String]);
for (NSOperation *theDependency in self.dependencies)
	[theDependency dump:inLevel + 1];
}

@end
