//
//  CLazyCache.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CLazyCache.h"

@interface CLazyCache ()
@property (readwrite, nonatomic, assign) NSUInteger capacity;
@property (readwrite, nonatomic, retain) NSMutableDictionary *cachedObjectsByKey;
@property (readwrite, nonatomic, retain) NSMutableArray *cachedObjects;
@end

@implementation CLazyCache

@synthesize capacity;
@synthesize cachedObjectsByKey;
@synthesize cachedObjects;

- (id)initWithCapacity:(NSInteger)inCapacity
{
if ((self = [self init]) != NULL)
	{
	self.capacity = inCapacity;
	self.cachedObjectsByKey = [NSMutableDictionary dictionaryWithCapacity:self.capacity];
	self.cachedObjects = [NSMutableArray arrayWithCapacity:self.capacity];
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
self.cachedObjects = NULL;
//
[super dealloc];
}

#pragma mark -

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

- (NSMutableArray *)cachedObjects
{
if (cachedObjects == NULL)
	{
	self.cachedObjects = [NSMutableArray arrayWithCapacity:self.capacity];
	}
return(cachedObjects); 
}

- (void)setCachedObjects:(NSMutableArray *)inCachedObjects
{
if (cachedObjects != inCachedObjects)
	{
	[cachedObjects autorelease];
	cachedObjects = [inCachedObjects retain];
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

if (self.cachedObjects.count >= self.capacity)
	{
	id theRemovedObject = [self.cachedObjects objectAtIndex:0];
	[theRemovedObject retain];
	[self.cachedObjects removeObjectAtIndex:0];
	[self.cachedObjectsByKey removeObjectForKey:inKey];
	[theRemovedObject release];
	}

[self.cachedObjects addObject:inObject];
[self.cachedObjectsByKey setObject:inObject forKey:inKey];
}

#pragma mark -

#if TARGET_OS_IPHONE
- (void)applicationDidReceiveMemoryWarningNotification:(NSNotification *)inNotification
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
self.cachedObjectsByKey = NULL;
self.cachedObjects = NULL;
//
[thePool release];
}
#endif /* TARGET_OS_IPHONE */

@end
