//
//  CWebDAVLock.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	WebDavLockScope_Unknown,
	WebDavLockScope_Exclusive,
	WebDavLockScope_Shared,
	} EWebDavLockScope;

typedef enum {
	WebDavLockType_Unknown,
	WebDavLockType_Write,
	} EWebDavLockType;

@class CHTTPMessage;
@class CXMLElement;

@interface CWebDAVLock : NSObject {
	NSURL *resource;
	NSString *token;
	NSInteger depth;
	NSDate *timeout;
	EWebDavLockScope scope;
	EWebDavLockType type;
	NSString *owner;
}

@property (readonly, retain) NSURL *resource;
@property (readonly, retain) NSString *token;
@property (readonly, assign) NSInteger depth;
@property (readonly, retain) NSDate *timeout;
@property (readonly, assign) EWebDavLockScope scope;
@property (readonly, assign) EWebDavLockType type;
@property (readonly, retain) NSString *owner;

+ (CWebDAVLock *)WebDavLockWithHTTPRequest:(CHTTPMessage *)inRequest error:(NSError **)outError;

- (CXMLElement *)asActiveLockElement;

- (NSString *)debuggingDescription;

@end
