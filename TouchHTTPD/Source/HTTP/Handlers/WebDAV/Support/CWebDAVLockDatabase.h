//
//  CWebDAVLockDatabase.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CWebDAVLock;

@interface CWebDAVLockDatabase : NSObject {
	NSMutableDictionary *locksByToken;
	NSMutableDictionary *locksByResource;
}

- (CWebDAVLock *)lockByToken:(NSString *)inToken;
- (CWebDAVLock *)lockByResource:(NSURL *)inResource;

- (void)addLock:(CWebDAVLock *)inLock;
- (void)removeLock:(CWebDAVLock *)inLock;

@end
