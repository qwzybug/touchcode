//
//  NSError_XMLOutputExtensions.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TouchXML.h"

@interface NSError (NSError_XMLOutputExtensions)

- (NSData *)asXMLData;
- (CXMLDocument *)asXMLDocument;
- (CXMLElement *)asXMLElement;

@end
