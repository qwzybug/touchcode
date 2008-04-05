//
//  CUserDefaultsHTTPClient.m
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CUserDefaultsHTTPClient.h"

#import "CJSONDeserializer.h"

@implementation CUserDefaultsHTTPClient

@synthesize host;
@synthesize port;

+ (CUserDefaultsHTTPClient *)standardUserDefaults
{
CUserDefaultsHTTPClient *theClient = [[[self alloc] init] autorelease];
theClient.host = [NSHost currentHost];
theClient.port = 8765;
return(theClient);
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
NSString *theStringValue = NULL;

if ([inValue isKindOfClass:[NSString class]])
	{
	theType = @"string";
	theStringValue = inValue;
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
	theStringValue = [inValue stringValue];
	}
else if ([inValue isKindOfClass:[NSArray class]])
	{
	theType = @"array";
	theStringValue = [inValue stringValue];
	}
else if ([inValue isKindOfClass:[NSArray class]])
	{
	theType = @"array";
	theStringValue = [inValue stringValue];
	}
else if ([inValue isKindOfClass:[NSDate class]])
	{
	theType = @"date";
	theStringValue = [inValue stringValue];
	}
else
	{
	NSAssert(NO, @"Cannot setObject for object of that type.");
	}


NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/key/%@?value=%@&type=%@", self.host.name, self.port, inDefaultName, theStringValue, theType]];

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
[theRequest setHTTPMethod:@"PUT"];

NSURLResponse *theResponse = NULL;
NSError *theError = NULL;
NSData *theData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
NSLog(@"%@ %@", theResponse, theData);
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
