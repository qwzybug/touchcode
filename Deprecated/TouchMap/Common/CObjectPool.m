//
//  CObjectPool.m
//  TouchCode
//
//  Created by Jonathan Wight on 08/10/08.
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
//NSLog(@"POOL SIZE: %d", self.spareObjects.count);

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
//NSLog(@"POOL SIZE: %d", self.spareObjects.count);

NSAssert(inObject != NULL, @"");

[self.spareObjects addObject:inObject];
}

@end
