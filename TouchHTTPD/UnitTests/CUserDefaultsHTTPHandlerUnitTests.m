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
	
	sleep(1);
	}
}

- (void)testWritingReadingStrings
{
[self prepare];

id theInputValue = @"banana";
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:@"test"];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"];
STAssertEqualObjects(theOutputValue, theInputValue, NULL);
}

- (void)testWritingReadingIntegers
{
[self prepare];

id theInputValue = [NSNumber numberWithInt:42];
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:@"test"];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"];
STAssertEqualObjects(theOutputValue, theInputValue, NULL);
}

- (void)testWritingReadingFloats
{
[self prepare];

id theInputValue = [NSNumber numberWithDouble:3.14];
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:@"test"];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"];
STAssertEqualObjects(theOutputValue, theInputValue, NULL);
STAssertEquals([theOutputValue doubleValue], [theInputValue doubleValue], NULL);
}

- (void)testWritingReadingArrays
{
[self prepare];

id theInputValue = [NSArray arrayWithObjects:@"A", @"B", @"C", NULL];
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:@"test"];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"];
STAssertEqualObjects(theOutputValue, theInputValue, NULL);
}

- (void)testWritingReadingDictionaries
{
[self prepare];

id theInputValue = [NSDictionary dictionaryWithObjectsAndKeys:@"xyzzy", @"foo", @"neep", @"bar", NULL];
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:@"test"];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"];
STAssertEqualObjects(theOutputValue, theInputValue, NULL);
}

/*
- (void)testWritingReadingDates
{
[self prepare];

id theInputValue = [NSDate date];
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:@"test"];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"];
STAssertEqualObjects(theOutputValue, theInputValue, NULL);
}
*/

@end
