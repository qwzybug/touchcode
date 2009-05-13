//
//  CHTTPMessage.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <CFNetwork/CFHTTPMessage.h>
#endif /* TARGET_OS_IPHONE */

#import "CChunkWriter.h"

#define kHTTPVersion1_0 (NSString *)kCFHTTPVersion1_0
#define kHTTPVersion1_1 (NSString *)kCFHTTPVersion1_1

#define kHTTPStatusCode_OK			200
#define kHTTPStatusCode_Created		201
#define kHTTPStatusCode_Accepted	202

@interface CHTTPMessage : NSObject <CChunkWriterDelegate> {
	CFHTTPMessageRef message;
	id body;
	NSError *error;
	BOOL chunked;
	id bodyWriter;
}

@property (readwrite, assign) CFHTTPMessageRef message;
@property (readwrite, retain) NSData *headerData;
@property (readwrite, retain) id body;
@property (readwrite, retain) NSData *bodyData; // JIWTODO deprecated
@property (readwrite, retain) NSStream *bodyStream; // JIWTODO deprecated
@property (readwrite, retain) NSError *error;
@property (readwrite, retain) id bodyWriter;	

+ (CHTTPMessage *)HTTPMessageRequest;
+ (CHTTPMessage *)HTTPMessageResponseWithStatusCode:(NSInteger)inStatusCode statusDescription:(NSString *)inStatusDescription httpVersion:(NSString *)inHTTPVersion;

// JIWTODO move to request category subclass?
- (NSString *)requestMethod;
- (NSURL *)requestURL;

- (NSString *)HTTPVersion;

// JIWTODO move to response category subclass?
- (NSInteger)responseStatusCode;

- (void)appendData:(NSData *)inData;

- (BOOL)isHeaderComplete;
- (BOOL)requestHasBody;
- (BOOL)isMessageComplete;

- (NSString *)headerForKey:(NSString *)inKey;
- (void)setHeader:(NSString *)inHeader forKey:(NSString *)inKey;

- (NSData *)serializedMessage;

- (NSString *)debuggingDescription;

@end
