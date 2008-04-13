//
//  CUserDefaultsHTTPClient.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPClient.h"

#import "NSString_Extensions.h"

#import </usr/include/objc/objc-class.h>

static CUserDefaultsHTTPClient *gInstance = NULL;

@interface CUserDefaultsHTTPClient ()
@property (readwrite, retain) NSNetService *service;
@property (readwrite, assign) BOOL serviceResolveFinished;
- (NSURL *)URLForKey:(NSString *)inKey;
@end

#pragma mark -

@implementation CUserDefaultsHTTPClient

@synthesize host;
@synthesize port;
@synthesize service;
@synthesize serviceResolveFinished;
@synthesize authUsername;
@synthesize authPassword;

+ (CUserDefaultsHTTPClient *)standardUserDefaults
{
if (gInstance == NULL)
	{
	NSAutoreleasePool *theAutoreleasePool = [[NSAutoreleasePool alloc] init];
	
	CUserDefaultsHTTPClient *theClient = [[[self alloc] init] autorelease];
//	theClient.host = [NSHost currentHost];
//	theClient.port = 8080;
	gInstance = [theClient retain];
	
	[theAutoreleasePool release];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	NSLog(@"Searching for netservices!");
	NSError *theError;
	BOOL theResult = [self findService:&theError];
	if (theResult == NO)
		return(NULL);
	NSLog(@"Found netservices: %@ %d", self.host, self.port);
	}
return(self);
}

- (void)dealloc
{
self.host = NULL;
self.service = NULL;
//
[super dealloc];
}

- (BOOL)findService:(NSError **)outError
{
self.service = NULL;

NSNetServiceBrowser *theNetService = [[NSNetServiceBrowser alloc] init];
theNetService.delegate = self;
[theNetService searchForServicesOfType:@"_userdefaults._tcp." inDomain:@""];

NSLog(@"Searching for services of type.");

NSDate *theStartDate = [NSDate date];
while (self.service == NULL && [[NSDate date] timeIntervalSinceDate:theStartDate] < 15.0)
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	
[theNetService release];
theNetService = NULL;

if (self.service == NULL)
	{
	if (outError)
		*outError = [NSError errorWithDomain:@"CUserDefaultsHTTPClient_Domain" code:-1 userInfo:NULL];
	return(NO);
	}

NSLog(@"Resolving service.");

self.serviceResolveFinished = NO;
self.service.delegate = self;
[self.service resolveWithTimeout:15.0];

while (self.serviceResolveFinished == NO)
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

if (self.service == NULL)
	{
	NSLog(@"Failed to resolve.h");
	if (outError)
		*outError = [NSError errorWithDomain:@"CUserDefaultsHTTPClient_Domain" code:-2 userInfo:NULL];
	return(NO);
	}

NSLog(@"Resolved");

self.host = [NSHost hostWithName:self.service.hostName];
self.port = self.service.port;

return(YES);
}

#pragma mark -

- (id)objectForKey:(NSString *)inKey
{
NSURL *theURL = [self URLForKey:inKey];

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
[theRequest setHTTPMethod:@"GET"];

NSHTTPURLResponse *theResponse = NULL;
NSError *theError = NULL;
NSData *theData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];

id theObject = NULL;
if ([theResponse statusCode] == 200)
	{
	NSString *theErrorString = NULL;
	NSDictionary *theDictionary = [NSPropertyListSerialization propertyListFromData:theData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&theErrorString];
	theObject = [theDictionary objectForKey:@"value"];
	}

return(theObject);
}

- (void)setObject:(id)inValue forKey:(NSString *)inKey
{
NSString *theType = NULL;

if ([inValue isKindOfClass:[NSString class]])
	{
	theType = @"string";
	}
else if ([inValue isKindOfClass:[NSNumber class]])
	{
	switch (CFNumberGetType((CFNumberRef)inValue))
		{
		case kCFNumberSInt8Type:
		case kCFNumberSInt16Type:
		case kCFNumberSInt32Type:
		case kCFNumberSInt64Type:
		case kCFNumberCharType:
		case kCFNumberShortType:
		case kCFNumberIntType:
		case kCFNumberLongType:
		case kCFNumberLongLongType:
		case kCFNumberCFIndexType:
		case kCFNumberNSIntegerType:
			theType = @"integer";
			break;
		case kCFNumberFloat32Type:
		case kCFNumberFloat64Type:
		case kCFNumberFloatType:
		case kCFNumberDoubleType:
		default:
			theType = @"real";
			break;
		}
	}
else if ([inValue isKindOfClass:[NSArray class]])
	{
	theType = @"array";
	}
else if ([inValue isKindOfClass:[NSDictionary class]])
	{
	theType = @"dict";
	}
else if ([inValue isKindOfClass:[NSDate class]])
	{
	theType = @"date";
	}
else
	{
	NSAssert(NO, @"Cannot setObject for object of that type.");
	}

NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:inValue forKey:@"value"];
NSString *theErrorString = NULL;
NSData *theValueData = [NSPropertyListSerialization dataFromPropertyList:theDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&theErrorString];
	
NSURL *theURL = [self URLForKey:inKey];
//NSLog(@"%@", theURL);

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
[theRequest setHTTPMethod:@"POST"];
if (theValueData)
	[theRequest setHTTPBody:theValueData];

NSHTTPURLResponse *theResponse = NULL;
NSError *theError = NULL;
NSData *theData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
if (theError != NULL)
	[NSException raise:NSGenericException format:@"setObject:forKey: returned with error %@", theError];
else if (theResponse.statusCode != 200)
	{
	[NSException raise:NSGenericException format:@"setObject:forKey: returned with %d (%@)", theResponse.statusCode, [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease]];;
	}
}

- (void)removeObjectForKey:(NSString *)inKey
{
NSURL *theURL = [self URLForKey:inKey];

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
[theRequest setHTTPMethod:@"DELETE"];

NSURLResponse *theResponse = NULL;
NSError *theError = NULL;
[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
}

- (NSURL *)URLForKey:(NSString *)inKey
{

NSURL *theURL = NULL;
if (self.authUsername != NULL && self.authPassword != NULL)
	theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@?%@:%d/key/%@", self.authUsername, self.authPassword, self.host.name, self.port, [inKey stringByObsessivelyAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
else
	theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, [inKey stringByObsessivelyAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
return(theURL);
}

#pragma mark -

- (void)netServiceBrowser:(NSNetServiceBrowser *)inNetServiceBrowser didFindService:(NSNetService *)inNetService moreComing:(BOOL)inMoreServicesComing
{
#pragma unused (inNetServiceBrowser, inMoreServicesComing)
self.service = inNetService;
}

- (void)netServiceDidResolveAddress:(NSNetService *)inSender
{
NSLog(@"SUCCESS");
if (inSender == self.service)
	{
	self.serviceResolveFinished = YES;
	}
}

- (void)netService:(NSNetService *)inSender didNotResolve:(NSDictionary *)errorDict;
{
#pragma unused (errorDict)
NSLog(@"FAILED");
if (inSender == self.service)
	{
	self.service = NULL;
	self.serviceResolveFinished = YES;
	}
}

@end

#pragma mark -

@implementation CUserDefaultsHTTPClient (CUserDefaultsHTTPClient_ConvenienceExtensions)

/*
- (NSString *)stringForKey:(NSString *)inKey;
- (NSArray *)arrayForKey:(NSString *)inKey;
- (NSDictionary *)dictionaryForKey:(NSString *)inKey;
- (NSData *)dataForKey:(NSString *)inKey;
- (NSArray *)stringArrayForKey:(NSString *)inKey;
- (NSInteger)integerForKey:(NSString *)inKey;
- (float)floatForKey:(NSString *)inKey;
- (double)doubleForKey:(NSString *)inKey;
- (BOOL)boolForKey:(NSString *)inKey;

- (void)setInteger:(NSInteger)value forKey:(NSString *)inKey;
- (void)setFloat:(float)value forKey:(NSString *)inKey;
- (void)setDouble:(double)value forKey:(NSString *)inKey;
- (void)setBool:(BOOL)value forKey:(NSString *)inKey;

- (NSDictionary *)dictionaryRepresentation;
*/

@end
