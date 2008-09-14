//
//  CRemoteQueryServer.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/21/08.
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

#import "CRemoteQueryServer.h"

#import "CCompletionTicket.h"
#import "CURLConnectionManager.h"
#import "NSObject_InvocationGrabberExtensions.h"

NSString *const kRemoteQueryServerDefaultChannelName = @"kRemoteQueryServerDefaultChannelName";
NSString *const kHTTPStatusCodeErrorDomain = @"kHTTPStatusCodeErrorDomain";

@interface CRemoteQueryServer ()
@end

#pragma mark -

@implementation CRemoteQueryServer

@synthesize rootURL;
@dynamic connectionChannelName;
@dynamic operationQueue;
@synthesize deserializer;

- (void)dealloc
{
[self.operationQueue waitUntilAllOperationsAreFinished];
//
self.rootURL = NULL;
self.connectionChannelName = NULL;
self.operationQueue = NULL;
self.deserializer = NULL;
//	
[super dealloc];
}

#pragma mark -

- (NSString *)connectionChannelName
{
if (connectionChannelName == NULL)
	self.connectionChannelName = kRemoteQueryServerDefaultChannelName;
return(connectionChannelName); 
}

- (void)setConnectionChannelName:(NSString *)inConnectionChannelName
{
if (connectionChannelName != inConnectionChannelName)
	{
	[connectionChannelName autorelease];
	connectionChannelName = [inConnectionChannelName retain];
	}
}

- (NSOperationQueue *)operationQueue
{
if (operationQueue == NULL)
	self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
return(operationQueue); 
}

- (void)setOperationQueue:(NSOperationQueue *)inOperationQueue
{
if (operationQueue != inOperationQueue)
	{
	[operationQueue autorelease];
	operationQueue = [inOperationQueue retain];
	}
}

- (id <CDeserializerProtocol>)deserializer
{
if (deserializer == NULL)
	self.deserializer = [CJSONDeserializer deserializer];
return(deserializer); 
}

- (void)setDeserializer:(id <CDeserializerProtocol>)inDeserializer
{
if (deserializer != inDeserializer)
	{
	[deserializer autorelease];
	deserializer = [inDeserializer retain];
	}
}

#pragma mark -

- (NSURLRequest *)requestWithRelativeURL:(NSURL *)inRelativeURL
{
NSURL *theURL = [NSURL URLWithString:[inRelativeURL relativeString] relativeToURL:self.rootURL];

// TODO cache policy and timeout policys?

NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

return(theRequest);
}

- (NSMutableURLRequest *)mutableRequestWithRelativeURL:(NSURL *)inRelativeURL
{
NSURL *theURL = [NSURL URLWithString:[inRelativeURL relativeString] relativeToURL:self.rootURL];

// TODO cache policy and timeout policys?

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];

return(theRequest);
}

- (void)addQueryWithURLRequest:(NSURLRequest *)inRequest completionTicket:(CCompletionTicket *)inCompletionTicket
{
NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	inCompletionTicket, @"completionTicket",
	NULL];

CCompletionTicket *theCompletionTicket = [[[CCompletionTicket alloc] initWithIdentifier:NULL delegate:self userInfo:theUserInfo] autorelease];

CManagedURLConnection *theURLConnection = [[[CManagedURLConnection alloc] initWithRequest:inRequest completionTicket:theCompletionTicket] autorelease];

[[CURLConnectionManager instance] addAutomaticURLConnection:theURLConnection toChannel:self.connectionChannelName];
}

#pragma mark -

- (void)deserializeQueryDataForConnection:(CManagedURLConnection *)inConnection
{
NSDictionary *theDictionary = NULL;
NSError *theError = NULL;

// TODO -- should really work with non HTTP responses.
NSAssert([inConnection.response isKindOfClass:[NSHTTPURLResponse class]], @"Response should be a HTTP response.");

if (((NSHTTPURLResponse *)inConnection.response).statusCode == 200)
	{
	theDictionary = [self.deserializer deserializeAsDictionary:inConnection.data error:&theError];
	}
else
	{
	theError = [NSError errorWithDomain:kHTTPStatusCodeErrorDomain code:((NSHTTPURLResponse *)inConnection.response).statusCode userInfo:NULL];
	}

if (theDictionary == NULL)
	{
	CCompletionTicket *theCompletionTicket = [inConnection.completionTicket.userInfo objectForKey:@"completionTicket"];
	if (theCompletionTicket)
		{
		[[theCompletionTicket grabInvocationAndPerformOnMainThreadWaitUntilDone:NO] didFailForTarget:inConnection error:theError];
		}
	}
else
	{
	CCompletionTicket *theCompletionTicket = [inConnection.completionTicket.userInfo objectForKey:@"completionTicket"];
	if (theCompletionTicket)
		{
		[[theCompletionTicket grabInvocationAndPerformOnMainThreadWaitUntilDone:NO] didCompleteForTarget:inConnection result:theDictionary];
		}
	}
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
NSInvocationOperation *theOperation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(deserializeQueryDataForConnection:) object:inTarget] autorelease];
[self.operationQueue addOperation:theOperation];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError;
{
CCompletionTicket *theCompletionTicket = [inCompletionTicket.userInfo objectForKey:@"completionTicket"];
if (theCompletionTicket)
	{
	[[theCompletionTicket grabInvocationAndPerformOnMainThreadWaitUntilDone:NO] didFailForTarget:inTarget error:inError];
	}
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget;
{
CCompletionTicket *theCompletionTicket = [inCompletionTicket.userInfo objectForKey:@"completionTicket"];
if (theCompletionTicket)
	{
	[[theCompletionTicket grabInvocationAndPerformOnMainThreadWaitUntilDone:NO] didCancelForTarget:inTarget];
	}
}

@end
