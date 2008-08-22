//
//  CRemoteQueryServer.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CRemoteQueryServer.h"

#import "CURLConnectionManager.h"

NSString *const kRemoteQueryServerDefaultChannelName = @"kRemoteQueryServerDefaultChannelName";
NSString *const kHTTPStatusCodeErrorDomain = @"kHTTPStatusCodeErrorDomain";

@implementation CRemoteQueryServer

@synthesize rootURL;
@dynamic connectionChannelName;
@dynamic operationQueue;
@synthesize deserializer;
@synthesize delegate;

- (void)dealloc
{
[self.operationQueue waitUntilAllOperationsAreFinished];
//
self.rootURL = NULL;
self.connectionChannelName = NULL;
self.operationQueue = NULL;
self.deserializer = NULL;
self.delegate = NULL;
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
NSURL *theURL = [NSURL URLWithString:[inRelativeURL relativePath] relativeToURL:self.rootURL];

// TODO cache policy and timeout policys?

NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];

return(theRequest);
}

- (NSMutableURLRequest *)mutableRequestWithRelativeURL:(NSURL *)inRelativeURL
{
NSURL *theURL = [NSURL URLWithString:[inRelativeURL relativePath] relativeToURL:self.rootURL];

// TODO cache policy and timeout policys?

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];

return(theRequest);
}

- (void)addQueryWithURLRequest:(NSURLRequest *)inRequest identifier:(NSString *)inIdentifier userInfo:(id)inUserInfo
{
CManagedURLConnection *theURLConnection = [[[CManagedURLConnection alloc] initWithRequest:inRequest identifier:inIdentifier delegate:self userInfo:inUserInfo] autorelease];

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
	SEL theSelector = @selector(didFailWithConnection:error:);
	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:theSelector]];
	theInvocation.selector = theSelector;
	[theInvocation setArgument:&inConnection atIndex:2];
	[theInvocation setArgument:&theError atIndex:3];
	[theInvocation retainArguments];
	//
	[theInvocation performSelectorOnMainThread:@selector(invokeWithTarget:) withObject:self waitUntilDone:YES];
	}
else
	{
	SEL theSelector = @selector(didSucceedWithConnection:resultDictionary:);
	NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:theSelector]];
	theInvocation.selector = theSelector;
	[theInvocation setArgument:&inConnection atIndex:2];
	[theInvocation setArgument:&theDictionary atIndex:3];
	[theInvocation retainArguments];
	//
	[theInvocation performSelectorOnMainThread:@selector(invokeWithTarget:) withObject:self waitUntilDone:YES];
	}
}

- (void)didSucceedWithConnection:(CManagedURLConnection *)inConnection resultDictionary:(NSDictionary *)inResultDictionary
{
[self.delegate remoteQueryServer:self didSucceedWithIdentifier:inConnection.identifier resultDictionary:inResultDictionary];
}

- (void)didFailWithConnection:(CManagedURLConnection *)inConnection error:(NSError *)inError
{
[self.delegate remoteQueryServer:self didFailWithIdentifier:inConnection.identifier error:inError];
}

#pragma mark -

- (void)connection:(CManagedURLConnection *)inConnection didSucceedWithResponse:(NSURLResponse *)inResponse
{
NSInvocationOperation *theOperation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(deserializeQueryDataForConnection:) object:inConnection] autorelease];
[self.operationQueue addOperation:theOperation];
}

- (void)connection:(CManagedURLConnection *)inConnection didFailWithError:(NSError *)inError
{
SEL theSelector = @selector(didFailWithConnection:error:);
NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:theSelector]];
theInvocation.selector = theSelector;
theInvocation.target = self;
[theInvocation setArgument:&inConnection atIndex:2];
[theInvocation setArgument:&inError atIndex:3];
[theInvocation retainArguments];
//
[theInvocation performSelectorOnMainThread:@selector(invoke) withObject:NULL waitUntilDone:NO];
}

- (void)connectionDidCancel:(CManagedURLConnection *)inConnection
{
// We just swallow cancellations. Any better ideas?
}

@end
