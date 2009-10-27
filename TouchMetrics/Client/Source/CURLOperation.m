//
//  CURLOperation.m
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CURLOperation.h"

#import "CTemporaryData.h"

@interface CURLOperation ()
@property (readwrite, assign) BOOL isExecuting;
@property (readwrite, assign) BOOL isFinished;
@property (readwrite, retain) NSURLRequest *request;
@property (readwrite, retain) NSURLConnection *connection;
@property (readwrite, retain) NSURLResponse *response;
@property (readwrite, retain) NSError *error;
@property (readwrite, retain) CTemporaryData *temporaryData;
@end

@implementation CURLOperation

@synthesize isExecuting;
@synthesize isFinished;
@synthesize request;
@synthesize connection;
@synthesize response;
@synthesize error;
@dynamic data;
@synthesize temporaryData;
@synthesize userInfo;

- (id)initWithRequest:(NSURLRequest *)inRequest
{
if ((self = [self init]) != NULL)
	{
	isExecuting = NO;
	isFinished = NO;
	
	request = [inRequest copy];
	}
return(self);
}

- (void)dealloc
{
[request release];
request = NULL;
[connection release];
connection = NULL;
[response release];
response = NULL;
[error release];
error = NULL;
[temporaryData release];
temporaryData = NULL;
//	
[super dealloc];
}

#pragma mark -

- (BOOL)isConcurrent
{
return(YES);
}

- (NSData *)data
{
return(self.temporaryData.data);
}

#pragma mark -

- (void)start
{
self.isExecuting = YES;
self.connection = [[[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES] autorelease];
}

- (void)cancel
{
[self.connection cancel];
self.connection = NULL;
//
[super cancel];
}

#pragma mark -

- (NSURLRequest *)connection:(NSURLConnection *)inConnection willSendRequest:(NSURLRequest *)inRequest redirectResponse:(NSURLResponse *)response
{
return(inRequest);
}

//- (BOOL)connection:(NSURLConnection *)inConnection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//}
//
//- (NSInputStream *)connection:(NSURLConnection *)inConnection needNewBodyStream:(NSURLRequest *)request
//{
//}
//
//- (void)connection:(NSURLConnection *)inConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//}
//
//- (void)connection:(NSURLConnection *)inConnection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//}
//
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)inConnection
//{
//}

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse
{
self.response = inResponse;
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData
{
if (self.temporaryData == NULL)
	{
	self.temporaryData = [[[CTemporaryData alloc] initWithDataLimit:64 * 1024] autorelease];
	}
NSError *theError = NULL;
BOOL theResult = [self.temporaryData writeData:inData error:&theError];
if (theResult == NO)
	{
	self.error = theError;
	[self cancel];
	}
}

//- (void)connection:(NSURLConnection *)inConnection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
//{
//}
//

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection
{
NSLog(@"DID FINISH: %@", self);

[self willChangeValueForKey:@"isFinished"];
self.isFinished = YES;
[self didChangeValueForKey:@"isFinished"];

self.isExecuting = NO;
self.connection = NULL;
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError
{
NSLog(@"DID FAIL: %@", inError);

self.error = inError;

self.isFinished = YES;
self.isExecuting = NO;
self.connection = NULL;
}

//- (NSCachedURLResponse *)connection:(NSURLConnection *)inConnection willCacheResponse:(NSCachedURLResponse *)cachedResponse
//{
//}

//- (NSString *)description
//{
//return([NSString stringWithFormat:@"isFinished:%d", self.isFinished]);;
//}

@end
