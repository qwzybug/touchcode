//
//  CManagedURLConnection.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCompletionTicket;

/** A URL Connection that does most of the grunt work for you. You should generally use this with CURLConnectionManager. */
@interface CManagedURLConnection : NSObject {
	CCompletionTicket *completionTicket;

	NSURLRequest *request;
	NSInteger priority;
	NSString *channel;
	NSURLConnection *connection;
	NSURLResponse *response;
	id data;
	BOOL dataIsMutable;
	
	NSTimeInterval startTime;
	NSTimeInterval endTime;
}

@property (readwrite, nonatomic, retain) CCompletionTicket *completionTicket;

@property (readonly, nonatomic, retain) NSURLRequest *request;
@property (readwrite, nonatomic, assign) NSInteger priority;
@property (readwrite, nonatomic, retain) NSString *channel;

@property (readonly, nonatomic, retain) NSURLConnection *connection;
@property (readonly, nonatomic, retain) NSURLResponse *response;
 
@property (readonly, nonatomic, retain) NSData *data;

@property (readonly, nonatomic, assign) NSTimeInterval startTime;
@property (readonly, nonatomic, assign) NSTimeInterval endTime;

- (id)initWithRequest:(NSURLRequest *)inRequest completionTicket:(CCompletionTicket *)inCompletionTicket;

- (void)start;
- (void)cancel;

@end
