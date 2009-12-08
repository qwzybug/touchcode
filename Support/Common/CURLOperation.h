//
//  CURLOperation.h
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTemporaryData;

@interface CURLOperation : NSOperation {
	BOOL isExecuting;
	BOOL isFinished;
	NSURLRequest *request;
	NSURLConnection *connection;
	NSURLResponse *response;
	NSError *error;
	CTemporaryData *temporaryData;
	id userInfo;
}

@property (readonly, retain) NSURLRequest *request;
@property (readonly, retain) NSURLConnection *connection;
@property (readonly, retain) NSURLResponse *response;
@property (readonly, retain) NSError *error;
@property (readonly, retain) NSData *data;
@property (readwrite, retain) id userInfo;

- (id)initWithRequest:(NSURLRequest *)inRequest;

@end
