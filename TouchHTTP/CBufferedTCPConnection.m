//
//  CBufferedTCPConnection
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CBufferedTCPConnection.h"

@interface CBufferedTCPConnection ()
@property (readwrite, retain) NSMutableData *inputBuffer;
@property (readwrite, retain) NSMutableData *outputBuffer;

- (void)flushOutputBuffer;
@end

@implementation CBufferedTCPConnection

@dynamic inputBuffer;
@dynamic outputBuffer;

- (void)dealloc
{
self.inputBuffer = NULL;
self.outputBuffer = NULL;
//
[super dealloc];
}

- (NSMutableData *)inputBuffer
{
if (inputBuffer == NULL)
	{
	inputBuffer = [[NSMutableData dataWithLength:1024] retain];
	}
return(inputBuffer); 
}

- (void)setInputBuffer:(NSMutableData *)inInputBuffer
{
if (inputBuffer != inInputBuffer)
	{
	[inputBuffer autorelease];
	inputBuffer = [inInputBuffer retain];
    }
}

- (NSMutableData *)outputBuffer
{
if (outputBuffer == NULL)
	{
	outputBuffer = [[NSMutableData data] retain];
	}
return(outputBuffer); 
}

- (void)setOutputBuffer:(NSMutableData *)inOutputBuffer
{
if (outputBuffer != inOutputBuffer)
	{
	[outputBuffer autorelease];
	outputBuffer = [inOutputBuffer retain];
    }
}

- (void)inputStreamHandleEvent:(NSStreamEvent)inEventCode
{
if (inEventCode == NSStreamEventHasBytesAvailable)
	{
	NSData *theData = NULL;
	// NSInputStream
	uint8_t *theBufferPtr = NULL;
	NSInteger theBufferLength = 0;
	BOOL theResult = [self.inputStream getBuffer:&theBufferPtr length:(NSUInteger *)&theBufferLength];
	if (theResult == NO)
		{
		theBufferPtr = self.inputBuffer.mutableBytes;
		theBufferLength = [self.inputStream read:theBufferPtr maxLength:self.inputBuffer.length];
		if (theBufferLength < 0)
			{
			NSLog(@"TODO read returned %d (%d)", theBufferLength, self.inputStream.hasBytesAvailable);
			return;
			}
		}

	theData = [NSData dataWithBytesNoCopy:theBufferPtr length:theBufferLength freeWhenDone:NO];

	[self dataReceived:theData];
	}
}

- (void)outputStreamHandleEvent:(NSStreamEvent)inEventCode
{
if (inEventCode == NSStreamEventHasSpaceAvailable)
	{
	[self flushOutputBuffer];
	}
}

- (void)dataReceived:(NSData *)inData;
{
#pragma unused (inData)
NSLog(@"You should probably override dataReceived:");
}

- (void)sendData:(NSData *)inData
{
[self.outputBuffer appendData:inData];

if (self.outputStream.hasSpaceAvailable)
	{
	[self.outputBuffer appendData:inData];
	[self flushOutputBuffer];
	}
else
	{
	[self.outputBuffer appendData:inData];
	}
}

- (void)flushOutputBuffer
{
if (outputBuffer != NULL)
	{
	NSUInteger theBufferLength = self.outputBuffer.length;
	if (theBufferLength > 0)
		{
		UInt8 *thePtr = self.outputBuffer.mutableBytes;
		NSUInteger theBytesWritten = [self.outputStream write:thePtr maxLength:theBufferLength];
		if (theBytesWritten == theBufferLength)
			{
			self.outputBuffer.length = 0;
			}
		else if (theBytesWritten > 0)
			{
			self.outputBuffer = [NSMutableData dataWithBytes:thePtr + theBytesWritten length:theBufferLength - theBytesWritten];
			}
		else if (theBytesWritten < 0)
			[NSException raise:NSGenericException format:@"Error TODO"];
		else if (theBytesWritten == 0)
			[NSException raise:NSGenericException format:@"Error TODO"];
		}
	}
}

@end
