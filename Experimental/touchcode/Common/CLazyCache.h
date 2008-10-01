//
//  CLazyCache.h
//  TouchCode
//
//  Created by Jonathan Wight on 9/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A really quick and easy in memory cache. Clears itself during low-memory on iPhone. */
@interface CLazyCache : NSDateFormatter {
	NSUInteger capacity;
	NSMutableDictionary *cachedObjectsByKey;
	NSMutableArray *cachedObjects;
}

@property (readonly, nonatomic, assign) NSUInteger capacity;

- (id)initWithCapacity:(NSInteger)inCapacity;

- (id)cachedObjectForKey:(id)inKey;
- (void)cacheObject:(id)inObject forKey:(id)inKey;

@end
