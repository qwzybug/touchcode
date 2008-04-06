//
//  CTCPConnection.m
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CTCPConnection.h"

#import "CTCPSocketListener.h"

@interface CTCPConnection ()
@property (readwrite, assign) CTCPSocketListener *server;
@property (readwrite, retain) NSData *address;
@property (readwrite, retain) NSInputStream *inputStream;
@property (readwrite, retain) NSOutputStream *outputStream;
@end

@implementation CTCPConnection

@synthesize server;
@synthesize address;
@synthesize inputStream;
@synthesize outputStream;

- (id)initWithTCPServer:(CTCPSocketListener *)inServer address:(NSData *)inAddress inputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream
{
if ((self = [self init]) != NULL)
	{
	self.server = inServer;
	self.address = inAddress;
	self.inputStream = inInputStream;
	self.outputStream = inOutputStream;
	
	self.inputStream.delegate = self;
	self.outputStream.delegate = self;
	}
return(self);
}

- (void)dealloc
{
self.server = NULL;
self.address = NULL;
self.inputStream = NULL;
self.outputStream = NULL;

[super dealloc];
}

- (BOOL)open:(NSError **)outError
{
#pragma unused (outError)
[self.server connectionWillOpen:self];

[self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
[self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];

[self.inputStream open];
[self.outputStream open];

[self.server connectionDidOpen:self];

return(YES);
}

- (void)close
{
[self.server connectionWillClose:self];

[self.inputStream close];
[self.outputStream close];

[self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
[self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];

self.inputStream.delegate = NULL;
self.outputStream.delegate = NULL;

[self.server connectionDidClose:self];
}

- (void)stream:(NSStream *)inStream handleEvent:(NSStreamEvent)inEventCode
{
if (inEventCode == NSStreamEventEndEncountered)
	{
	[self close];
	}
else
	{
	if (inStream == self.inputStream)
		{
		[self inputStreamHandleEvent:inEventCode];
		}
	else if (inStream == self.outputStream)
		{
		[self outputStreamHandleEvent:inEventCode];
		}
	else
		{
		NSAssert(NO, @"TODO");
		}
	}
}

- (void)inputStreamHandleEvent:(NSStreamEvent)inEventCode
{
#pragma unused (inEventCode)
NSLog(@"You should probably override inputStreamHandleEvent:");
}

- (void)outputStreamHandleEvent:(NSStreamEvent)inEventCode
{
#pragma unused (inEventCode)
NSLog(@"You should probably override outputStreamHandleEvent:");
}

@end
