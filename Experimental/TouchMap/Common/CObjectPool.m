//
//  CObjectPool.m
//  MapToy
//
//  Created by Jonathan Wight on 08/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CObjectPool.h"

@interface CObjectPool ()
@property (readwrite, nonatomic, assign) Class objectClass;
@property (readwrite, nonatomic, assign) SEL creationSelector;
@property (readwrite, nonatomic, retain) NSMutableSet *spareObjects;
@end

#pragma mark -

@implementation CObjectPool

@synthesize objectClass;
@synthesize creationSelector;
@synthesize spareObjects;

- (id)initWithObjectClass:(Class)inObjectClass creationSelector:(SEL)inCreationSelector
{
if ((self = [self init]) != NULL)
	{
	self.objectClass = inObjectClass;
	self.creationSelector = inCreationSelector;
	self.spareObjects = [NSMutableSet set];
	}
return(self);
}

- (void)dealloc
{
self.spareObjects = NULL;
//
[super dealloc];
}

#pragma mark -

- (id)createObject
{
NSLog(@"POOL SIZE: %d", self.spareObjects.count);

id theObject = NULL;
if (self.spareObjects.count > 0)
	{
	theObject = [self.spareObjects anyObject];
	[[theObject retain] autorelease];
	[self.spareObjects removeObject:theObject];
	}
else
	{
	NSAssert(self.objectClass != NULL, @"");
	NSAssert(self.creationSelector != NULL, @"");
	NSAssert([self.objectClass respondsToSelector:self.creationSelector], @"");
	
	theObject = [self.objectClass performSelector:self.creationSelector];
	}

return(theObject);
}

- (void)returnObjectToPool:(id)inObject
{
NSLog(@"POOL SIZE: %d", self.spareObjects.count);

NSAssert(inObject != NULL, @"");

[self.spareObjects addObject:inObject];
}

@end
