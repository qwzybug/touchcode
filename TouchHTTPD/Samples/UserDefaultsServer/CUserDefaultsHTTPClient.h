//
//  CUserDefaultsHTTPClient.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/05/08.
//  Copyright (c) 2008 Jonathan Wight
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
