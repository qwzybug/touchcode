//
//  CHTTPFileSystemHandler.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPRequestHandler.h"

@protocol CFileSystem;

@interface CHTTPFileSystemHandler : NSObject <CHTTPRequestHandler> {
	NSString *rootPath;
	id <CFileSystem> fileSystem;
	BOOL handlesPut;
}

@property (readonly, retain) NSString *rootPath;
@property (readwrite, retain) id <CFileSystem> fileSystem;
@property (readwrite, assign) BOOL handlesPut;

- (id)initWithRootPath:(NSString *)inRootPath;

@end
