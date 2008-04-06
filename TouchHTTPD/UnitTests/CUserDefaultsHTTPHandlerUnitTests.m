//
//  CUserDefaultsHTTPHandlerUnitTests.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPHandlerUnitTests.h"

#import "CUserDefaultsHTTPHandler.h"
#import "CTCPServer.h"
#import "CUserDefaultsHTTPClient.h"

@implementation CUserDefaultsHTTPHandlerUnitTests

@synthesize queue;
@synthesize server;
@synthesize requestHandler;

- (void)prepare
{
if (self.server == NULL)
	{
	self.requestHandler = [[[CUserDefaultsHTTPHandler alloc] init] autorelease];

	self.server = [[[CTCPServer alloc] init] autorelease];
	self.server.delegate = self.requestHandler;
	self.server.type = @"_http._tcp.";

	NSInvocationOperation *theServerOperation = [[[NSInvocationOperation alloc] initWithTarget:self.server selector:@selector(serveForever) object:NULL] autorelease];

	self.queue = [[[NSOperationQueue alloc] init] autorelease];
	[self.queue addOperation:theServerOperation];

	[CUserDefaultsHTTPClient standardUserDefaults].host = [NSHost currentHost];
	[CUserDefaultsHTTPClient standardUserDefaults].port = self.server.port;
	
	}
}

- (void)tearDown
{
[self.server stop];
self.server = NULL;
self.requestHandler = NULL;
self.queue = NULL;
}

- (void)testWritingReadingStrings
{
[self prepare];

id theInputValue = @"banana";
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);

[self tearDown];
}

- (void)testWritingReadingIntegers
{
[self prepare];

id theInputValue = [NSNumber numberWithInt:42];
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);

[self tearDown];
}

- (void)testWritingReadingDoubles
{
[self prepare];

id theInputValue = [NSNumber numberWithDouble:3.14];
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);

[self tearDown];
}

- (void)testWritingReadingArrays
{
[self prepare];

id theInputValue = [NSArray arrayWithObjects:@"A", @"B", @"C", NULL];
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);

[self tearDown];
}

- (void)testWritingReadingDictionaries
{
[self prepare];

id theInputValue = [NSDictionary dictionaryWithObjectsAndKeys:@"xyzzy", @"foo", @"neep", @"bar", NULL];
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);

[self tearDown];
}

- (void)testWritingReadingDates
{
[self prepare];

id theInputValue = [NSDate date];
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects([theInputValue description], [[self.requestHandler.store objectForKey:theKey] description], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects([theInputValue description], [theOutputValue description], NULL);

[self tearDown];
}

#pragma mark -

- (void)testDeletions
{
[self prepare];

id theInputValue = @"banana";
NSString *theKey = @"some_key";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] removeObjectForKey:theKey];
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertNil(theOutputValue, NULL);

[self tearDown];
}

/*
- (void)testFunkeyKeyNames
{
[self prepare];

id theInputValue = @"banana";
NSString *theKey = @"this is & a = key with a / funny | name";
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
STAssertEqualObjects(theInputValue, [self.requestHandler.store objectForKey:theKey], NULL);
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertEqualObjects(theInputValue, theOutputValue, NULL);
[[CUserDefaultsHTTPClient standardUserDefaults] removeObjectForKey:theKey];
STAssertNil([self.requestHandler.store objectForKey:theKey], NULL);
theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
STAssertNil(theOutputValue, NULL);

[self tearDown];
}
*/

@end
