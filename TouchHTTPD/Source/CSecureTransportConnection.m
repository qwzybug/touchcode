//
//  CSecureTransportConnection.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CSecureTransportConnection.h"

static OSStatus MySSLReadFunc(SSLConnectionRef connection, void *data, size_t *dataLength);
static OSStatus MySSLWriteFunc(SSLConnectionRef connection, const void *data, size_t *dataLength);

@interface CSecureTransportConnection ()

@property (readwrite, assign) SSLContextRef context;
@property (readwrite, retain) NSMutableData *inputBuffer;

@end

@implementation CSecureTransportConnection

@synthesize certificates;
@dynamic context;
@synthesize inputBuffer;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.inputBuffer = [NSMutableData data];
	}
return(self);
}

- (void)dealloc
{
self.inputBuffer = NULL;
	
[super dealloc];
}

#pragma mark -

- (SSLContextRef)context
{
if (context == NULL)
	{
	SSLContextRef theContext;
	OSStatus theStatus = SSLNewContext(YES, &theContext);
	if (theStatus != noErr)
		[NSException raise:NSGenericException format:@"SSLNewContext failed with %d", theStatus];
		
	theStatus = SSLSetIOFuncs(theContext, MySSLReadFunc, MySSLWriteFunc);
	if (theStatus != noErr)
		[NSException raise:NSGenericException format:@"SSLSetIOFuncs failed with %d", theStatus];
	
	theStatus = SSLSetCertificate(theContext, (CFArrayRef)self.certificates);
	if (theStatus != noErr)
		[NSException raise:NSGenericException format:@"SSLSetCertificate failed with %d", theStatus];

	theStatus = SSLSetConnection(theContext, self); 
	if (theStatus != noErr)
		[NSException raise:NSGenericException format:@"SSLSetConnection failed with %d", theStatus];

	SSLSessionState theState;
	theStatus = SSLGetSessionState(theContext, &theState);
	if (theStatus != noErr)
		[NSException raise:NSGenericException format:@"SSLSetConnection failed with %d", theStatus];

	NSLog(@"SSLGetSessionState:%d %d", theStatus, theState);
	
	context = theContext;
	}
return(context);
}

- (void)setContext:(SSLContextRef)inContext
{
if (context != inContext)
	{
	if (context)
		{
		SSLDisposeContext(context);
		}
	context = inContext;
	}
}

#pragma mark -

- (void)close
{
NSLog(@"************ CLOSE");
[super close];
}

- (void)dataReceived:(NSData *)inData
{
NSLog(@"**** Data Received: %d bytes", inData.length);
[self.inputBuffer appendData:inData];

SSLSessionState theState;
OSStatus theStatus = SSLGetSessionState(self.context, &theState);
if (theStatus != noErr)
	[NSException raise:NSGenericException format:@"SSLGetSessionState failed with %d", theStatus];
if (theState == kSSLIdle || theState == kSSLHandshake)
	{
	NSLog(@"Starting handshake.");
	theStatus = SSLHandshake(self.context);
	if (theStatus != noErr && theStatus != errSSLWouldBlock)
		[NSException raise:NSGenericException format:@"SSLHandshake failed with %d", theStatus];
	NSLog(@"SSLHandshake: %d", theStatus);
	}
else if (theState >= kSSLConnected)
	{
	NSLog(@"**** Connected! Sending to next connection in stack.");
	size_t theBufferLength = 0;
	theStatus = SSLGetBufferedReadSize(self.context, &theBufferLength);
	if (theStatus != noErr)
		[NSException raise:NSGenericException format:@"SSLGetBufferedReadSize failed with %d", theStatus];
	NSLog(@"SSLGetBufferedReadSize: %d / Buffer Size: %d", theBufferLength, self.inputBuffer.length);
	
	if (theBufferLength > 0)
		{
		NSMutableData *theData = [NSMutableData dataWithLength:theBufferLength];
		size_t theProcessedLength = 0;
		theStatus = SSLRead(self.context, [theData mutableBytes], theBufferLength, &theProcessedLength);
		theData.length = theProcessedLength;
		if (theStatus != noErr)
			[NSException raise:NSGenericException format:@"SSLRead failed with %d", theStatus];
		[super dataReceived:theData];
		}
	}
}

@end

static OSStatus MySSLReadFunc(SSLConnectionRef inConnection, void *data, size_t *dataLength)
{
NSLog(@"**** MySSLReadFunc: desired %d bytes", *dataLength);

CSecureTransportConnection *theConnection = (CSecureTransportConnection *)inConnection;

const size_t theBufferLength = theConnection.inputBuffer.length;
const size_t theActualDataLength = MIN(*dataLength, theBufferLength);
NSLog(@"**** MySSLReadFunc: have %d bytes", theActualDataLength);


[theConnection.inputBuffer getBytes:data length:theActualDataLength];

if (theActualDataLength < theBufferLength)
	theConnection.inputBuffer = [NSMutableData dataWithBytes:(char *)theConnection.inputBuffer.mutableBytes + theActualDataLength length:theBufferLength - theActualDataLength];
else
	theConnection.inputBuffer = [NSMutableData data];

NSLog(@"**** MySSLReadFunc: reamining %d bytes", theConnection.inputBuffer.length);

	
if (theActualDataLength < *dataLength)
	{
	*dataLength = theActualDataLength;
	return(errSSLWouldBlock);
	}
else
	{
	*dataLength = theActualDataLength;
	return(noErr);
	}
}

static OSStatus MySSLWriteFunc(SSLConnectionRef inConnection, const void *data, size_t *dataLength)
{
NSLog(@"**** MySSLWriteFunc: %d bytes", *dataLength);
CSecureTransportConnection *theConnection = (CSecureTransportConnection *)inConnection;
NSData *theData = [NSData dataWithBytesNoCopy:(void *)data length:*dataLength freeWhenDone:NO];
[theConnection sendData:theData];
return(noErr);
}
