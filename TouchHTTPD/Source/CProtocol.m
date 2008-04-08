//
//  CProtocol.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CProtocol.h"

@implementation CProtocol

@synthesize lowerLink;
@synthesize upperLink;

- (void)dealloc
{
self.lowerLink = NULL;
self.upperLink = NULL;
//
[super dealloc];
}

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
size_t theCount = 0;
if (self.lowerLink)
	theCount = [self.lowerLink sendData:inData];
return(theCount);
}

@end
