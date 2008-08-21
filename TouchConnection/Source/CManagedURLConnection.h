//
//  CManagedURLConnection.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CManagedURLConnectionDelegate;
@class CURLConnectionManager;

@interface CManagedURLConnection : NSObject {
	CURLConnectionManager *manager; // Never retained.

	NSString *identifier;

	NSURLRequest *request;
	id <CManagedURLConnectionDelegate> delegate;
	BOOL useFileFlag;
	id userInfo;
	NSInteger priority;
	NSString *channel;

	NSURLConnection *connection;
	NSURLResponse *response;
	id data;
	BOOL dataIsMutable;
	NSString *filePath;
	NSFileHandle *fileHandle;
	
	NSTimeInterval startTime;
	NSTimeInterval endTime;
}

@property (readwrite, nonatomic, assign) CURLConnectionManager *manager; // TODO -- really need to make this read only.

@property (readonly, nonatomic, retain) NSString *identifier;

@property (readonly, nonatomic, retain) NSURLRequest *request;
@property (readwrite, nonatomic, assign) id <CManagedURLConnectionDelegate> delegate;
@property (readwrite, nonatomic, assign) BOOL useFileFlag;
@property (readwrite, nonatomic, retain) id userInfo;
@property (readwrite, nonatomic, assign) NSInteger priority;
@property (readwrite, nonatomic, retain) NSString *channel;

@property (readonly, nonatomic, retain) NSURLConnection *connection;
@property (readonly, nonatomic, retain) NSURLResponse *response;
 
@property (readonly, nonatomic, retain) NSData *data;
@property (readonly, nonatomic, retain) NSString *filePath;
@property (readonly, nonatomic, retain) NSFileHandle *fileHandle;

@property (readonly, nonatomic, assign) NSTimeInterval startTime;
@property (readonly, nonatomic, assign) NSTimeInterval endTime;

- (id)initWithRequest:(NSURLRequest *)inRequest identifier:(NSString *)inIdentifier delegate:(id <CManagedURLConnectionDelegate>)inDelegate userInfo:(id)inUserInfo;

- (void)start;
- (void)cancel;

@end

#pragma mark -

@protocol CManagedURLConnectionDelegate <NSObject>
@optional
- (void)connection:(CManagedURLConnection *)inConnection didSucceedWithResponse:(NSURLResponse *)inResponse;
- (void)connection:(CManagedURLConnection *)inConnection didFailWithError:(NSError *)inError;
- (void)connectionDidCancel:(CManagedURLConnection *)inConnection;
@end