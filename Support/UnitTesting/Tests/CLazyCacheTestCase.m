//
//  CLazyCacheTestCase.m
//  UnitTesting
//
//  Created by Jonathan Wight on 6/25/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "CLazyCacheTestCase.h"

#import "CLazyCache.h"

@implementation CLazyCacheTestCase

- (void)testCache1
{
CLazyCache *theCache = [[[CLazyCache alloc] initWithCapacity:2] autorelease];
STAssertEquals(theCache.capacity, 2U, @"Capacity doesn't match");
STAssertEquals(theCache.count, 0U, @"Count not 0");
[theCache cacheObject:@"A" forKey:@"1"];
STAssertEquals(theCache.count, 1U, @"Count not 1");
[theCache cacheObject:@"B" forKey:@"2"];
STAssertEquals(theCache.count, 2U, @"Count not 2");
[theCache cacheObject:@"C" forKey:@"3"];
STAssertEquals(theCache.count, 2U, @"Count not 2");

STAssertEqualObjects([theCache cachedObjectForKey:@"3"], @"C", @"Mismatch");
STAssertEqualObjects([theCache cachedObjectForKey:@"2"], @"B", @"Mismatch");
STAssertEqualObjects([theCache cachedObjectForKey:@"1"], NULL, @"Mismatch");
}

@end
