//
//  CUserDefaultsHTTPClient.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CUserDefaultsHTTPClient : NSObject {
	NSHost *host;
	NSInteger port;
}

@property (readwrite, retain) NSHost *host;
@property (readwrite, assign) NSInteger port;

+ (CUserDefaultsHTTPClient *)standardUserDefaults;

- (id)objectForKey:(NSString *)inDefaultName;
- (void)setObject:(id)value forKey:(NSString *)inDefaultName;
- (void)removeObjectForKey:(NSString *)inDefaultName;

@end

#pragma mark -

@interface CUserDefaultsHTTPClient (CUserDefaultsHTTPClient_ConvenienceExtensions)
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
