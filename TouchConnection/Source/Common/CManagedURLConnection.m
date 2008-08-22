//
//  CManagedURLConnection.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CManagedURLConnection.h"

#import "CURLConnectionManager.h"

//#define DEBUG 1
#if URL_LOGGING
#define _Log(...) NSLog
#else
#define _Log(...)
#endif

@interface CManagedURLConnection ()
@property (readwrite, nonatomic, assign) CURLConnectionManager *manager;
@property (readwrite, nonatomic, retain) NSURLRequest *request;
@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, nonatomic, retain) NSURLConnection *connection;
@property (readwrite, nonatomic, retain) NSURLResponse *response;
@property (readwrite, nonatomic, retain) NSData *data;
@property (readwrite, nonatomic, assign) NSTimeInterval startTime;
@property (readwrite, nonatomic, assign) NSTimeInterval endTime;

@end;

#pragma mark -

@implementation CManagedURLConnection

@synthesize manager;
@synthesize request;
@synthesize identifier;
@synthesize delegate;
@synthesize userInfo;
@synthesize priority;
@synthesize channel;
@synthesize connection;
@synthesize response;
@synthesize data;
@synthesize startTime;
@synthesize endTime;

- (id)initWithRequest:(NSURLRequest *)inRequest identifier:(NSString *)inIdentifier delegate:(id <CManagedURLConnectionDelegate>)inDelegate userInfo:(id)inUserInfo;
{
if ((self = [self init]) != NULL)
	{
	self.request = inRequest;
	self.identifier = inIdentifier;
	self.delegate = inDelegate;
	self.userInfo = inUserInfo;
	}
return(self);
}

- (void)dealloc
{
[self.connection cancel];

self.manager = NULL;
self.identifier = NULL;
self.request = NULL;
self.delegate = NULL;
self.userInfo = NULL;
self.channel = NULL;
self.connection = NULL;
self.response = NULL;
self.data = NULL;
//
[super dealloc];
} 

#pragma mark -

- (void)start
{
_Log(@"START");

self.startTime = [[NSDate date] timeIntervalSinceReferenceDate];

self.connection = [[[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO] autorelease];
[self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
[self.connection start];
}

- (void)cancel
{
_Log(@"CANCEL");

if (self.connection)
	{
	[self.connection cancel];
	self.connection = NULL;
	}

if (self.delegate && [self.delegate respondsToSelector:@selector(connectionDidCancel:)])
	[self.delegate connectionDidCancel:self];

if (self.manager)
	[self.manager connectionDidCancel:self];

// No reason to keep the delegate or manage around if we cancel.
self.delegate = NULL;
self.manager = NULL;
}

#pragma mark -

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse
{
if (self.connection == NULL)
	{
	NSLog(@"Received event after connction has been reset. This is bad.");
	return;
	}
NSAssert(self.connection == inConnection, NULL);

_Log(@"DID RECEIVE RESPONSE");

self.response = inResponse;
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData
{
if (self.connection == NULL)
	{
	NSLog(@"Received event after connction has been reset. This is bad.");
	return;
	}
NSAssert(self.connection == inConnection, NULL);

_Log(@"DID RECEIVE DATA");

if (self.data == NULL)
	{
	// Let's just store this data!
	data = [inData retain];
	dataIsMutable = NO;
	}
else
	{
	if (dataIsMutable == YES)
		{
		// self.data is already NSMutableData. We just need to append.
		[data appendData:inData];
		}
	else
		{
		// We have some data, but it is NSData. We need to make a mutable copy first then append.
		NSMutableData *theCopy = [self.data mutableCopy];
		[data release];
		data = theCopy;
		[data appendData:inData];
		dataIsMutable = YES;
		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection
{
if (self.connection == NULL)
	{
	NSLog(@"Received event after connction has been reset. This is bad.");
	return;
	}
NSAssert(self.connection == inConnection, NULL);

_Log(@"DID FINISH LOADING");

self.endTime = [[NSDate date] timeIntervalSinceReferenceDate];

if (self.delegate && [self.delegate respondsToSelector:@selector(connection:didSucceedWithResponse:)])
	[self.delegate connection:self didSucceedWithResponse:self.response];
		
if (self.manager)
	[self.manager connection:self didSucceedWithResponse:self.response];
	
self.connection = NULL;
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError
{
if (self.connection == NULL)
	{
	NSLog(@"Received event after connction has been reset. This is bad.");
	return;
	}
NSAssert(self.connection == inConnection, NULL);

_Log(@"DID FINISH LOADING");

self.endTime = [[NSDate date] timeIntervalSinceReferenceDate];

if (self.delegate && [self.delegate respondsToSelector:@selector(connection:didFailWithError:)])
	[self.delegate connection:self didFailWithError:inError];

if (self.manager)
	[self.manager connection:self didFailWithError:inError];

self.connection = NULL;
}

@end
