//
//  CTempFile.h
//  FileServer
//
//  Created by Jonathan Wight on 12/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTempFile : NSObject {
	BOOL deleteOnDealloc;
	NSString *suffix;
	NSString *path;
	int fileDescriptor;
	NSFileHandle *fileHandle;
}

@property (readwrite, assign) BOOL deleteOnDealloc;
@property (readwrite, retain) NSString *suffix;
@property (readonly, retain) NSString *path;
@property (readonly, assign) int fileDescriptor;
@property (readonly, retain) NSFileHandle *fileHandle; // JIWTODO - THIS SHOULD NOT BE HERE. Strong binding bad.

+ (NSString *)temporaryDirectory;

+ (CTempFile *)tempFile;

- (void)create;

@end
