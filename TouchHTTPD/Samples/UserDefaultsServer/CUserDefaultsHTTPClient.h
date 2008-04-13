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
	NSNetService *service;
	BOOL serviceResolveFinished;
	NSString *authUsername;
	NSString *authPassword;
}

@property (readwrite, retain) NSHost *host;
@property (readwrite, assign) NSInteger port;
@property (readwrite, retain) NSString *authUsername;
@property (readwrite, retain) NSString *authPassword;

+ (CUserDefaultsHTTPClient *)standardUserDefaults;

- (BOOL)findService:(NSError **)outError;

- (id)objectForKey:(NSString *)inKey;
- (void)setObject:(id)value forKey:(NSString *)inKey;
- (void)removeObjectForKey:(NSString *)inKey;

@end

#pragma mark -

@interface CUserDefaultsHTTPClient (CUserDefaultsHTTPClient_ConvenienceExtensions)
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
