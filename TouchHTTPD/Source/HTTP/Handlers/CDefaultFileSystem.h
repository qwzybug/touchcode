//
//  CDefaultFileSystem.h
//  FileServer
//
//  Created by Jonathan Wight on 1/2/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFileSystem.h"

@interface CDefaultFileSystem : NSObject <CFileSystem> {
	NSFileManager *fileManager;
	NSString *rootDirectory;
	BOOL supportAppleDouble;
	BOOL showDotFiles;
}

@property (readwrite, retain) NSFileManager *fileManager;
@property (readwrite, retain) NSString *rootDirectory;
@property (readwrite, assign) BOOL supportAppleDouble;
@property (readwrite, assign) BOOL showDotFiles;

- (id)initWithRootDirectory:(NSString *)inRootDirectory;

- (NSString *)absolutePathForRelativePath:(NSString *)inRelativePath;

@end
