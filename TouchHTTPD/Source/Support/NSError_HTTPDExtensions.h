//
//  NSError_HTTPDExtensions.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHTTPMessage;

@interface NSError (NSError_HTTPDExtensions)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)inUnderlyingError request:(CHTTPMessage *)inRequest;
+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)inUnderlyingError request:(CHTTPMessage *)inRequest format:(NSString *)inFormat, ...;

@end
