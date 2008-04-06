//
//  CHTTPMessage.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kHTTPVersion1_0 (NSString *)kCFHTTPVersion1_0
#define kHTTPVersion1_1 (NSString *)kCFHTTPVersion1_1

@interface CHTTPMessage : NSObject {
	CFHTTPMessageRef message;
}

@property (readwrite, assign) CFHTTPMessageRef message;

+ (CHTTPMessage *)HTTPMessageRequest;
+ (CHTTPMessage *)HTTPMessageResponseWithStatusCode:(NSInteger)inStatusCode statusDescription:(NSString *)inStatusDescription httpVersion:(NSString *)inHTTPVersion;

- (NSString *)requestMethod;
- (NSURL *)requestURL;

- (void)appendData:(NSData *)inData;

- (BOOL)isHeaderComplete;

- (NSString *)headerForKey:(NSString *)inKey;
- (void)setHeader:(NSString *)inHeader forKey:(NSString *)inKey;

- (NSData *)body;
- (void)setBody:(NSData *)inBody;

- (void)setContentType:(NSString *)inContentType body:(NSData *)inBody;

- (NSData *)serializedMessage;

@end
