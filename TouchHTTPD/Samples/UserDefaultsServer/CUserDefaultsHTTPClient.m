//
//  CUserDefaultsHTTPClient.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPClient.h"

#import "NSString_Extensions.h"

static CUserDefaultsHTTPClient *gInstance = NULL;

@implementation CUserDefaultsHTTPClient

@synthesize host;
@synthesize port;

+ (CUserDefaultsHTTPClient *)standardUserDefaults
{
if (gInstance == NULL)
	{
	CUserDefaultsHTTPClient *theClient = [[[self alloc] init] autorelease];
	theClient.host = [NSHost currentHost];
	theClient.port = 8080;
	gInstance = [theClient retain];
	}
return(gInstance);
}

- (id)objectForKey:(NSString *)inKey
{
NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, [inKey stringByObsessivelyAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

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

NSString *theURLString = [NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, [inKey stringByObsessivelyAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
NSURL *theURL = [NSURL URLWithString:theURLString];
NSLog(@"%@", theURL);

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
NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, [inKey stringByObsessivelyAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
[theRequest setHTTPMethod:@"DELETE"];

NSURLResponse *theResponse = NULL;
NSError *theError = NULL;
NSData *theData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
NSLog(@"%@ %@", theResponse, theData);
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
