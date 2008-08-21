//
//  NSURL_JSONExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSURL_JSONExtensions.h"

@implementation NSURL (NSURL_JSONExtensions)

+ (NSURL *)URLWithRoot:(NSURL *)inRoot query:(NSString *)inQuery
{
NSString *theURLString = [NSString stringWithFormat:@"%@?%@", inRoot, inQuery];
return([self URLWithString:theURLString]);
}

+ (NSURL *)URLWithRoot:(NSURL *)inRoot queryDictionary:(NSDictionary *)inQueryDictionary
{
return([self URLWithRoot:inRoot query:[self queryStringForDictionary:inQueryDictionary]]);
}

+ (NSString *)queryStringForDictionary:(NSDictionary *)inQueryDictionary
{
NSMutableArray *theQueryComponents = [NSMutableArray array];
for (NSString *theKey in inQueryDictionary)
	{
	id theValue = [inQueryDictionary objectForKey:theKey];
	
	[theQueryComponents addObject:[NSString stringWithFormat:@"%@=%@", theKey, theValue]];
	}
return([theQueryComponents componentsJoinedByString:@"&"]);
}

@end
