//
//  CFileSystem.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 11/5/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TouchXML.h"

// JIWTODO -- work with URLs not path strings.

@protocol CFileSystem <NSObject>

- (NSString *)etagForItemAtPath:(NSString *)inPath;

- (BOOL)fileExistsAtPath:(NSString *)inPath isDirectory:(BOOL *)outIsDirectory;

- (BOOL)createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError **)error;

- (BOOL)copyItemAtPath:(NSString *)inSourcePath toPath:(NSString *)inDestinationPath error:(NSError **)outError;
- (BOOL)moveItemAtPath:(NSString *)inSourcePath toPath:(NSString *)inDestinationPath error:(NSError **)outError;
- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)inPath maximumDepth:(NSInteger)inMaximumDepth error:(NSError **)outError;

- (NSData *)contentsOfFileAtPath:(NSString *)inPath error:(NSError **)outError;
- (BOOL)writeContentsOfFileAtPath:(NSString *)inPath data:(NSData *)inData error:(NSError **)outError;

- (NSInputStream *)inputStreamForFileAtPath:(NSString *)inPath error:(NSError **)outError;

- (NSDictionary *)fileAttributesAtPath:(NSString *)inPath error:(NSError **)outError;

- (BOOL)moveLocalFileSystemItemAtPath:(NSString *)inSourcePath toPath:(NSString *)inDestinationPath error:(NSError **)outError;

@end
