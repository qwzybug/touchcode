//
//  MyDocument.m
//  AccelGathererServer
//
//  Created by Jonathan Wight on 8/26/08.
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

#import "MyDocument.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#import "CAcceleration.h"

static void MyCFSocketCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@implementation MyDocument

@synthesize port;
@synthesize socket;
@synthesize service;
@synthesize firstDate;
@synthesize arrayController = outletArrayController;

- (void) dealloc
{
	
[super dealloc];
}

- (NSString *)windowNibName 
{
return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
[super windowControllerDidLoadNib:windowController];

NSString *thePath = [[NSBundle mainBundle] pathForResource:@"Sphere" ofType:@"qtz"];
[outletQCView loadComposition:[QCComposition compositionWithFile:thePath]];

[outletArrayController addObserver:self forKeyPath:@"selectedObjects" options:0 context:NULL];

[self startServing:NULL];
}

- (void)close
{
[outletArrayController removeObserver:self forKeyPath:@"selectedObjects"];

self.service = NULL;

CFRelease(socket);
socket = NULL;

[super close];
}

- (BOOL)startPublishing:(NSError **)outError
{
self.service = [[[NSNetService alloc] initWithDomain:@"local." type:@"_accel._udp." name:@"TEST" port:self.port] autorelease];
self.service.delegate = self;
[self.service publish];

return(YES);
}

- (BOOL)startServing:(NSError **)outError
{
CFSocketContext theSocketContext = { 0, self, NULL, NULL, NULL };

CFSocketRef theSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketDataCallBack, MyCFSocketCallBack, &theSocketContext);

int theYesFlag = 1;
setsockopt(CFSocketGetNative(theSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&theYesFlag, sizeof(theYesFlag));

// set up the IPv4 endpoint; if port is 0, this will cause the kernel to choose a port for us
struct sockaddr_in theAddressStruct = { .sin_len = sizeof(theAddressStruct), .sin_family = AF_INET, .sin_port = htons(self.port), .sin_addr = htonl(INADDR_ANY) };
NSData *theAddress = [NSData dataWithBytes:&theAddressStruct length:sizeof(theAddressStruct)];

CFSocketError theResult = CFSocketSetAddress(theSocket, (CFDataRef)theAddress);
if (theResult != kCFSocketSuccess)
	{
	CFRelease(theSocket);
	
	if (outError)
		*outError = [NSError errorWithDomain:@"TODO" code:1 userInfo:NULL];
	return(NO);
	}

if (self.port == 0)
	{
	// now that the binding was successful, we get the port number 
	// -- we will need it for the v6 endpoint and for the NSNetService
	theAddress = [(NSData *)CFSocketCopyAddress(theSocket) autorelease];
	memcpy(&theAddressStruct, [theAddress bytes], [theAddress length]);
	self.port = ntohs(theAddressStruct.sin_port);
	}

CFRunLoopRef theRunLoop = CFRunLoopGetCurrent();
CFRunLoopSourceRef theRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, theSocket, 0);
CFRunLoopAddSource(theRunLoop, theRunLoopSource, kCFRunLoopCommonModes);
CFRelease(theRunLoopSource);

self.socket = theSocket;

[self startPublishing:NULL];

return(YES);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
CAcceleration *theAcceleration = outletArrayController.selectedObjects.lastObject;

[outletQCView setValue:[NSNumber numberWithFloat:theAcceleration.x / 2.0] forInputKey:@"x"];
[outletQCView setValue:[NSNumber numberWithFloat:theAcceleration.y / 2.0] forInputKey:@"y"];
[outletQCView setValue:[NSNumber numberWithFloat:theAcceleration.z / 2.0] forInputKey:@"z"];
}

@end

#pragma mark -

static void MyCFSocketCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
if (type == kCFSocketDataCallBack)
	{
	
	NSData *theData = (NSData *)data;
	NSString *theString = [[[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding] autorelease];
	
	NSTimeInterval theTimeInterval;
	float x, y, z;
	
	NSScanner *theScanner = [NSScanner scannerWithString:theString];
	[theScanner scanDouble:&theTimeInterval];
	[theScanner scanString:@"," intoString:NULL];
	[theScanner scanFloat:&x];
	[theScanner scanString:@"," intoString:NULL];
	[theScanner scanFloat:&y];
	[theScanner scanString:@"," intoString:NULL];
	[theScanner scanFloat:&z];
	
	MyDocument *theDocument = (MyDocument *)info;
	if (theDocument.firstDate == NULL)
		theDocument.firstDate = [NSDate date];
	
	CAcceleration *theAcceleration = [NSEntityDescription insertNewObjectForEntityForName:@"Acceleration" inManagedObjectContext:theDocument.managedObjectContext];
	
	theAcceleration.timestamp = [[[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:theDocument.firstDate] autorelease];
	theAcceleration.x = x;
	theAcceleration.y = y;
	theAcceleration.z = z;
	
	[theDocument.managedObjectContext processPendingChanges]; 

	[theDocument.arrayController setSelectionIndex:[theDocument.arrayController.arrangedObjects count] - 1];
	}
}


