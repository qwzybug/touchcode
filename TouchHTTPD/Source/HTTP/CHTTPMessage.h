//
//  CHTTPMessage.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright (c) 2008 Jonathan Wight
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_MAC == 1 && TARGET_OS_IPHONE == 0
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_MAC == 1 && TARGET_OS_IPHONE == 1
#import <CFNetwork/CFNetwork.h>
#endif

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
