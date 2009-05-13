//
//  CFileSystem_WebDAVExtensions.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/14/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CDefaultFileSystem.h"

@class CXMLElement;
@class CXMLDocument;
@class CWebDavHTTPHandler;

// JIWTODO this should NOT be a category on the file system. Put into CWebDAVHTTPHandler instead.

@interface CDefaultFileSystem (CFileSystem_WebDAVExtensions)

- (CXMLElement *)webDavPropResponseElementForHandler:(CWebDavHTTPHandler *)inHandler forPath:(NSString *)inPath properties:(CXMLDocument *)inDocument error:(NSError **)outError;

@end
