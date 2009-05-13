//
//  CWebDavHTTPHandler.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 10/31/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPFileSystemHandler.h"

@class CWebDAVLockDatabase;

@interface CWebDavHTTPHandler : CHTTPFileSystemHandler {
	CWebDAVLockDatabase *lockDatabase;
}

@property (readonly, retain) CWebDAVLockDatabase *lockDatabase;

- (NSString *)DAVClass;
- (NSArray *)allowedMethods;

@end
