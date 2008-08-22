//
//  CRemoteQueryServer.h
//  TouchCode
//
//  Created by Jonathan Wight on 8/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CManagedURLConnection.h"
#import "CJSONDeserializer.h"

extern NSString *const kRemoteQueryServerDefaultChannelName /* = @"kRemoteQueryServerDefaultChannelName" */;
extern NSString *const kHTTPStatusCodeErrorDomain /* = @"kHTTPStatusCodeErrorDomain" */;

@protocol CRemoteQueryServerDelegate;

@interface CRemoteQueryServer : NSObject <CManagedURLConnectionDelegate> {
	NSURL *rootURL;
	NSString *connectionChannelName;
	NSOperationQueue *operationQueue;
	id <CDeserializerProtocol> deserializer;
	id <CRemoteQueryServerDelegate> delegate;
}

@property (readwrite, retain) NSURL *rootURL;
@property (readwrite, retain) NSString *connectionChannelName;
@property (readwrite, retain) NSOperationQueue *operationQueue;
@property (readwrite, retain) id <CDeserializerProtocol> deserializer;
@property (readwrite, assign) id <CRemoteQueryServerDelegate> delegate;

- (NSURLRequest *)requestWithRelativeURL:(NSURL *)inRelativeURL;
- (NSMutableURLRequest *)mutableRequestWithRelativeURL:(NSURL *)inRelativeURL;

- (void)addQueryWithURLRequest:(NSURLRequest *)inRequest identifier:(NSString *)inIdentifier userInfo:(id)inUserInfo;

@end

#pragma mark -

@protocol CRemoteQueryServerDelegate <NSObject>

- (void)remoteQueryServer:(CRemoteQueryServer *)inRemoteQueryServer didSucceedWithIdentifier:(NSString *)inIdentifier resultDictionary:(NSDictionary *)inResultDictionary;
- (void)remoteQueryServer:(CRemoteQueryServer *)inRemoteQueryServer didFailWithIdentifier:(NSString *)inIdentifier error:(NSError *)inError;

@end