//
//  CHTTPMessage_WebDAVExtensions.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 11/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPMessage.h"

@class CXMLDocument;

@interface CHTTPMessage (CHTTPMessage_WebDAVExtensions)

- (BOOL)getDepth:(NSInteger *)outDepth; // JIWTODO Deprecated
- (NSNumber *)depth;
- (NSNumber *)overwrite;

- (CXMLDocument *)XMLBodyWithError:(NSError **)outError;

@end
