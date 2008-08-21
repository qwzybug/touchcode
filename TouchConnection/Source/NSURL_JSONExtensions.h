//
//  NSURL_JSONExtensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// TO BE DEPRECATED. These are just GET/PUT methods. Need to handle POST too.

@interface NSURL (NSURL_JSONExtensions)

+ (NSURL *)URLWithRoot:(NSURL *)inRoot query:(NSString *)inQuery;
+ (NSURL *)URLWithRoot:(NSURL *)inRoot queryDictionary:(NSDictionary *)inQueryDictionary;
+ (NSString *)queryStringForDictionary:(NSDictionary *)inQueryDictionary;

@end
