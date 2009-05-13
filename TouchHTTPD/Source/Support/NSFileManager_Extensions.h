//
//  NSFileManager_Extensions.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (NSFileManager_Extensions)

- (NSString *)mimeTypeForPath:(NSString *)inPath;

- (NSData *)appleDoubleDataForPath:(NSString *)inPath error:(NSError **)outError;
- (BOOL)setAppleDoubleData:(NSData *)inData forPath:(NSString *)inPath error:(NSError **)outError;

@end
