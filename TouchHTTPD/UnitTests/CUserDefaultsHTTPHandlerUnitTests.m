//
//  CUserDefaultsHTTPHandlerUnitTests.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
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

#import "CUserDefaultsHTTPHandlerUnitTests.h"

#import "CUserDefaultsHTTPRouter.h"
#import "CTCPSocketListener.h"
#import "CUserDefaultsHTTPClient.h"
#import "CHTTPServer.h"

@implementation CUserDefaultsHTTPHandlerUnitTests

@synthesize queue;
@synthesize server;
@synthesize requestRouter;

- (void)prepare
{
if (self.server == NULL)
	{
	self.requestRouter = [[[CUserDefaultsHTTPRouter alloc] init] autorelease];
	
	CRoutingHTTPRequestHandler *theRoutingRequestHandler = [[[CRoutingHTTPRequestHandler alloc] init] autorelease];
	theRoutingRequestHandler.router = self.requestRouter;

	self.server = [[[CHTTPServer alloc] init] autorelease];
	[self.server createDefaultSocketListener];
	[self.server.defaultRequestHandlers addObject:theRoutingRequestHandler];

	NSInvocationOperation *theServerOperation = [[[NSInvocationOperation alloc] initWithTarget:self.server.socketListener selector:@selector(serveForever) object:NULL] autorelease];

	self.queue = [[[NSOperationQueue alloc] init] autorelease];
	[self.queue addOperation:theServerOperation];

	[CUserDefaultsHTTPClient standardUserDefaults].host = [NSHost currentHost];
	[CUserDefaultsHTTPClient standardUserDefaults].port = self.server.socketListener.port;
	}
}

- (void)tearDown
{
[self.server.socketListener stop];
self.server = NULL;
self.requestRouter = NULL;
self.queue = NULL;
}

- (void)testWritingReadingStrings
{
[self prepare];

id theInputValue = @"banana";
NSString *theKey = @"some_key";
STAssertNil([self.requestRouter.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestRouter.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);

[self tearDown];
}

- (void)processKey:(NSString *)inKey value:(id)inValue
{
STAssertNil([self.requestRouter.store objectForKey:inKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:inValue forKey:inKey];
STAssertEqualObjects([inValue description], [[self.requestRouter.store objectForKey:inKey] description], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:inKey];
STAssertEqualObjects([inValue description], [theOutputValue description], NULL);
}

- (void)testWritingReadingIntegers
{
[self prepare];

id theInputValue = [NSNumber numberWithInt:42];
NSString *theKey = @"some_key";
[self processKey:theKey value:theInputValue];

[self tearDown];
}

- (void)testWritingReadingDoubles
{
[self prepare];

id theInputValue = [NSNumber numberWithDouble:3.14];
NSString *theKey = @"some_key";
[self processKey:theKey value:theInputValue];

[self tearDown];
}

- (void)testWritingReadingArrays
{
[self prepare];

id theInputValue = [NSArray arrayWithObjects:@"A", @"B", @"C", NULL];
NSString *theKey = @"some_key";
[self processKey:theKey value:theInputValue];

[self tearDown];
}

- (void)testWritingReadingDictionaries
{
[self prepare];

id theInputValue = [NSDictionary dictionaryWithObjectsAndKeys:@"xyzzy", @"foo", @"neep", @"bar", NULL];
NSString *theKey = @"some_key";
[self processKey:theKey value:theInputValue];

[self tearDown];
}

- (void)testWritingReadingDates
{
[self prepare];

id theInputValue = [NSDate date];
NSString *theKey = @"some_key";
[self processKey:theKey value:theInputValue];

[self tearDown];
}

- (void)testDeletions
{
[self prepare];

id theInputValue = @"banana";
NSString *theKey = @"some_key";
STAssertNil([self.requestRouter.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestRouter.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] removeObjectForKey:theKey];
STAssertNil([self.requestRouter.store objectForKey:theKey], NULL);
theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertNil(theOutputValue, NULL);

[self tearDown];
}

#pragma mark -

/*
- (void)testFunkeyKeyNames
{
[self prepare];

id theInputValue = @"banana";
NSString *theKey = @"this is & a = key with a / funny | name";
[self processKey:theKey value:theInputValue];

[self tearDown];
}
*/

@end
