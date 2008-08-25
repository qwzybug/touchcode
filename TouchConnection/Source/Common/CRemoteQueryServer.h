//
//  CRemoteQueryServer.h
//  TouchCode
//
//  Created by Jonathan Wight on 8/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCompletionTicket.h"
#import "CJSONDeserializer.h"

extern NSString *const kRemoteQueryServerDefaultChannelName /* = @"kRemoteQueryServerDefaultChannelName" */;
extern NSString *const kHTTPStatusCodeErrorDomain /* = @"kHTTPStatusCodeErrorDomain" */;

@interface CRemoteQueryServer : NSObject <CCompletionTicketDelegate> {
	NSURL *rootURL;
	NSString *connectionChannelName;
	NSOperationQueue *operationQueue;
	id <CDeserializerProtocol> deserializer;
}

@property (readwrite, retain) NSURL *rootURL;
@property (readwrite, retain) NSString *connectionChannelName;
@property (readwrite, retain) NSOperationQueue *operationQueue;
@property (readwrite, retain) id <CDeserializerProtocol> deserializer;

- (NSURLRequest *)requestWithRelativeURL:(NSURL *)inRelativeURL;
- (NSMutableURLRequest *)mutableRequestWithRelativeURL:(NSURL *)inRelativeURL;

- (void)addQueryWithURLRequest:(NSURLRequest *)inRequest completionTicket:(CCompletionTicket *)inCompletionTicket;

@end
