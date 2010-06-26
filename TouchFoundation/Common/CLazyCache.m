//
//  CLazyCache.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CLazyCache.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface CLazyCache ()
@property (readwrite, nonatomic, assign) NSUInteger capacity;
@property (readwrite, nonatomic, retain) NSMutableDictionary *cachedObjectsByKey;
@property (readwrite, nonatomic, retain) NSMutableArray *cachedKeys;

#if TARGET_OS_IPHONE
- (void)applicationDidReceiveMemoryWarningNotification:(NSNotification *)inNotification;
#endif

@end

#pragma mark -

@implementation CLazyCache

@synthesize capacity;
@synthesize cachedObjectsByKey;
@synthesize cachedKeys;

- (id)initWithCapacity:(NSInteger)inCapacity
{
if ((self = [self init]) != NULL)
	{
	self.capacity = inCapacity;
	self.cachedObjectsByKey = [NSMutableDictionary dictionaryWithCapacity:self.capacity];
	self.cachedKeys = [NSMutableArray arrayWithCapacity:self.capacity];
	//
	#if TARGET_OS_IPHONE
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
	#endif /* TARGET_OS_IPHONE */
	}
return(self);
}

- (void)dealloc
{
#if TARGET_OS_IPHONE
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
#endif /* TARGET_OS_IPHONE */
//
self.cachedObjectsByKey = NULL;
self.cachedKeys = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSUInteger)count
{
NSAssert(self.cachedKeys.count == self.cachedObjectsByKey.count, @"-[CLazyCache count] count mismatch. Cache is broken!");
return(self.cachedKeys.count);
}

- (NSMutableDictionary *)cachedObjectsByKey
{
if (cachedObjectsByKey == NULL)
	{
	self.cachedObjectsByKey = [NSMutableDictionary dictionaryWithCapacity:self.capacity];
	}
return(cachedObjectsByKey);
}

- (void)setCachedObjectsByKey:(NSMutableDictionary *)inCachedObjectsByKey
{
if (cachedObjectsByKey != inCachedObjectsByKey)
	{
	[cachedObjectsByKey autorelease];
	cachedObjectsByKey = [inCachedObjectsByKey retain];
    }
}

- (NSMutableArray *)cachedKeys
{
if (cachedKeys == NULL)
	{
	self.cachedKeys = [NSMutableArray arrayWithCapacity:self.capacity];
	}
return(cachedKeys);
}

- (void)setCachedKeys:(NSMutableArray *)inCachedKeys
{
if (cachedKeys != inCachedKeys)
	{
	[cachedKeys autorelease];
	cachedKeys = [inCachedKeys retain];
    }
}

#pragma mark -

- (id)cachedObjectForKey:(id)inKey
{
return([self.cachedObjectsByKey objectForKey:inKey]);
}

- (void)cacheObject:(id)inObject forKey:(id)inKey;
{
id theCurrentObject = [self.cachedObjectsByKey objectForKey:inKey];
if (theCurrentObject == inObject)
	return;

if (self.cachedKeys.count >= self.capacity)
	{
	id theRemovedKey = [self.cachedKeys objectAtIndex:0];
	[theRemovedKey retain];
	[self.cachedKeys removeObjectAtIndex:0];
	[self.cachedObjectsByKey removeObjectForKey:theRemovedKey];
	[theRemovedKey release];
	}

[self.cachedKeys addObject:inKey];
[self.cachedObjectsByKey setObject:inObject forKey:inKey];
}

#pragma mark -

#if TARGET_OS_IPHONE
- (void)applicationDidReceiveMemoryWarningNotification:(NSNotification *)inNotification
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
self.cachedObjectsByKey = NULL;
self.cachedKeys = NULL;
//
[thePool release];
}
#endif /* TARGET_OS_IPHONE */

@end
