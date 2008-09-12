//
//  CManagedURLConnection.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
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

#import "CManagedURLConnection.h"

#import "CCompletionTicket.h"

//#define DEBUG 1
#if URL_LOGGING
#define _Log(...) NSLog
#else
#define _Log(...)
#endif

@interface CManagedURLConnection ()
@property (readwrite, nonatomic, retain) NSURLRequest *request;
@property (readwrite, nonatomic, retain) NSURLConnection *connection;
@property (readwrite, nonatomic, retain) NSURLResponse *response;
@property (readwrite, nonatomic, retain) NSData *data;
@property (readwrite, nonatomic, assign) NSTimeInterval startTime;
@property (readwrite, nonatomic, assign) NSTimeInterval endTime;

@end;

#pragma mark -

@implementation CManagedURLConnection

@synthesize completionTicket;
@synthesize request;
@synthesize priority;
@synthesize channel;
@synthesize connection;
@synthesize response;
@synthesize data;
@synthesize startTime;
@synthesize endTime;

- (id)initWithRequest:(NSURLRequest *)inRequest completionTicket:(CCompletionTicket *)inCompletionTicket
{
if ((self = [self init]) != NULL)
	{
	self.request = inRequest;
	self.completionTicket = inCompletionTicket;
	}
return(self);
}

- (void)dealloc
{
[self.connection cancel];

self.completionTicket = NULL;
self.request = NULL;
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

[self.completionTicket didCancelForTarget:self];
}

#pragma mark -

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse
{
if (self.connection == NULL)
	{
	_Log(@"Received event after connction has been reset. This is bad.");
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
	_Log(@"Received event after connction has been reset. This is bad.");
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
	_Log(@"Received event after connction has been reset. This is bad.");
	return;
	}
NSAssert(self.connection == inConnection, NULL);

_Log(@"DID FINISH LOADING");

self.endTime = [[NSDate date] timeIntervalSinceReferenceDate];

[self.completionTicket didCompleteForTarget:self result:NULL];

self.connection = NULL;
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError
{
if (self.connection == NULL)
	{
	_Log(@"Received event after connction has been reset. This is bad.");
	return;
	}
NSAssert(self.connection == inConnection, NULL);

_Log(@"DID FINISH LOADING");

self.endTime = [[NSDate date] timeIntervalSinceReferenceDate];

[self.completionTicket didFailForTarget:self error:inError];

self.connection = NULL;

}

@end
