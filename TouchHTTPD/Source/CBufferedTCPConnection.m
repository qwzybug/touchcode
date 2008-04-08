//
//  CBufferedTCPConnection
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CBufferedTCPConnection.h"

@interface CBufferedTCPConnection ()
@property (readwrite, retain) NSMutableData *outputBuffer;

- (void)flushOutputBuffer;
@end

@implementation CBufferedTCPConnection

@synthesize outputBuffer;
@synthesize bufferOutput;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.outputBuffer = [NSMutableData data];
	}
return self;
}

- (void)dealloc
{
self.outputBuffer = NULL;
//
[super dealloc];
}

- (void)outputStreamHandleEvent:(NSStreamEvent)inEventCode
{
if (inEventCode == NSStreamEventHasSpaceAvailable || inEventCode == NSStreamEventHasBytesAvailable)
	{
	[self flushOutputBuffer];
	}
}

/*
- (void)dataReceived:(NSData *)inData;
{
#pragma unused (inData)
NSLog(@"You should probably override dataReceived:");
}
*/

- (size_t)sendData:(NSData *)inData
{
[self.outputBuffer appendData:inData];
[self flushOutputBuffer];
return(inData.length);
}

- (void)flushOutputBuffer
{
if ([self.outputStream hasSpaceAvailable] == NO)
	{
	return;
	}
NSUInteger theBufferLength = self.outputBuffer.length;
if (theBufferLength > 0)
	{
	UInt8 *thePtr = self.outputBuffer.mutableBytes;
	NSInteger theBytesWritten = [self.outputStream write:thePtr maxLength:theBufferLength];
	if (theBytesWritten == theBufferLength)
		{
		self.outputBuffer.length = 0;
		}
	else if (theBytesWritten >= 0)
		{
		NSLog(@"* Couldn't write everything to outputstream, storing rest in buffer.");
		self.outputBuffer = [NSMutableData dataWithBytes:thePtr + theBytesWritten length:theBufferLength - theBytesWritten];
		}
	}
}

@end
