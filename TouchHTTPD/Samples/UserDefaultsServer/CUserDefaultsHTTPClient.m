//
//  CUserDefaultsHTTPClient.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPClient.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

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

- (id)objectForKey:(NSString *)inDefaultName
{
NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, inDefaultName]];

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
[theRequest setHTTPMethod:@"GET"];

NSHTTPURLResponse *theResponse = NULL;
NSError *theError = NULL;
NSData *theData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];

id theObject = NULL;
if ([theResponse statusCode] == 200)
	{
	NSString *theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *theDictionary = [[CJSONDeserializer deserializer] deserialize:theString];
	theObject = [theDictionary objectForKey:@"value"];
	}

return(theObject);
}

- (void)setObject:(id)inValue forKey:(NSString *)inDefaultName
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
NSData *theValueData = [[[CJSONSerializer serializer] serializeDictionary:theDictionary] dataUsingEncoding:NSUTF8StringEncoding];

NSString *theURLString = [NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, inDefaultName];
	
NSURL *theURL = [NSURL URLWithString:theURLString];

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

- (void)removeObjectForKey:(NSString *)inDefaultName
{
NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/key/%@", self.host.name, self.port, inDefaultName]];

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
- (NSString *)stringForKey:(NSString *)inDefaultName;
- (NSArray *)arrayForKey:(NSString *)inDefaultName;
- (NSDictionary *)dictionaryForKey:(NSString *)inDefaultName;
- (NSData *)dataForKey:(NSString *)inDefaultName;
- (NSArray *)stringArrayForKey:(NSString *)inDefaultName;
- (NSInteger)integerForKey:(NSString *)inDefaultName;
- (float)floatForKey:(NSString *)inDefaultName;
- (double)doubleForKey:(NSString *)inDefaultName;
- (BOOL)boolForKey:(NSString *)inDefaultName;

- (void)setInteger:(NSInteger)value forKey:(NSString *)inDefaultName;
- (void)setFloat:(float)value forKey:(NSString *)inDefaultName;
- (void)setDouble:(double)value forKey:(NSString *)inDefaultName;
- (void)setBool:(BOOL)value forKey:(NSString *)inDefaultName;

- (NSDictionary *)dictionaryRepresentation;
*/

@end
