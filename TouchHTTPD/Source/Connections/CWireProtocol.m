//
//  CWireProtocol.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWireProtocol.h"

#import "CTransport.h"

@interface CWireProtocol ()
@end

#pragma mark -

@implementation CWireProtocol

@synthesize lowerLink;
@synthesize upperLink;
@dynamic transport;

- (void)dealloc
{
self.lowerLink = NULL;
self.upperLink = NULL;
//
[super dealloc];
}

#pragma mark -

- (CWireProtocol *)upperLink
{
return(upperLink); 
}

- (void)setUpperLink:(CWireProtocol *)inUpperLink
{
if (upperLink != inUpperLink)
	{
	if (upperLink != NULL)
		{
		upperLink.lowerLink = NULL;
		//
		[upperLink release];
		upperLink = NULL;
		}
	
	if (inUpperLink != NULL)
		{
		upperLink = [inUpperLink retain];
		upperLink.lowerLink = self;
		}
    }
}

- (CTransport *)transport
{
return(self.lowerLink.transport);
}

#pragma mark -

- (void)close
{
if (self.lowerLink)
	[self.lowerLink close];
}

- (void)dataReceived:(NSData *)inData
{
if (self.upperLink)
	[self.upperLink dataReceived:inData];
}

- (size_t)sendData:(NSData *)inData
{
//size_t theCount = 0;
//if (self.lowerLink)
//	theCount = [self.lowerLink sendData:inData];
//return(theCount);

NSInputStream *theStream = [NSInputStream inputStreamWithData:inData];
[self sendStream:theStream];
return(0);
}

- (void)sendStream:(NSInputStream *)inInputStream
{
if (self.lowerLink)
	[self.lowerLink sendStream:inInputStream];
}

@end
