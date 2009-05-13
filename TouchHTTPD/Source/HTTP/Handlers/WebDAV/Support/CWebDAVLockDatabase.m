//
//  CWebDAVLockDatabase.m
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CWebDAVLockDatabase.h"

#import "CWebDAVLock.h"

@interface CWebDAVLockDatabase ()

@property (readwrite, retain) NSMutableDictionary *locksByToken;
@property (readwrite, retain) NSMutableDictionary *locksByResource;

@end

#pragma mark -

@implementation CWebDAVLockDatabase

@synthesize locksByToken;
@synthesize locksByResource;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.locksByToken = [NSMutableDictionary dictionary];
	self.locksByResource = [NSMutableDictionary dictionary];
	}
return(self);
}

- (void)dealloc
{
self.locksByToken = NULL;
self.locksByResource = NULL;
//
[super dealloc];
}

#pragma mark -

- (CWebDAVLock *)lockByToken:(NSString *)inToken
{
return([self.locksByToken objectForKey:inToken]);
}

- (CWebDAVLock *)lockByResource:(NSURL *)inResource
{
return([self.locksByResource objectForKey:inResource]);
}

- (void)addLock:(CWebDAVLock *)inLock
{
[self.locksByToken setObject:inLock forKey:inLock.token];
[self.locksByResource setObject:inLock forKey:inLock.resource];
}

- (void)removeLock:(CWebDAVLock *)inLock
{
[inLock retain];

[self.locksByToken removeObjectForKey:inLock.token];
[self.locksByResource removeObjectForKey:inLock.resource];

[inLock release];
}

@end
