//
//  CLogging.h
//  TouchCode
//
//  Created by Jonathan Wight on 3/24/07.
//  Copyright 2009 Small Society. All rights reserved.
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

#import <Foundation/Foundation.h>

#include <stdarg.h>

#import "CCoreDataManager.h"
#import "FileFunctionLine.h"

typedef enum {
	LoggingLevel_EMERG = 0,
	LoggingLevel_ALERT = 1,
	LoggingLevel_CRIT = 2,
	LoggingLevel_ERR = 3,
	LoggingLevel_WARNING = 4,
	LoggingLevel_NOTICE = 5,
	LoggingLevel_INFO = 6,
	LoggingLevel_DEBUG = 7,
} ELoggingLevel;

enum {
	LoggingFlags_None = 0x00,
	LoggingFlags_WriteToSTDERR = 0x01,
	LoggingFlags_WriteToDatabase = 0x02,
	};

@class CBetterCoreDataManager;
@class NSManagedObjectID;

@protocol CLoggingHandler;

@interface CLogging : NSObject <CCoreDataManagerDelegate> {
	NSUInteger flags;
	NSString *sender;
	NSString *facility;
	CBetterCoreDataManager *coreDataManager;
	NSManagedObjectID *sessionID;
	NSMutableDictionary *handlers;
	BOOL started;
}

@property (readwrite, assign) NSUInteger flags;
@property (readwrite, copy) NSString *sender;
@property (readwrite, copy) NSString *facility;
@property (readonly, retain) CBetterCoreDataManager *coreDataManager;

@property (readonly, copy) NSManagedObjectID *sessionID;
@property (readonly, retain) NSManagedObject *session;

/** Returns the thread's logging isntance */
+ (CLogging *)instance;

+ (NSString *)stringForLevel:(NSInteger)inLevel;

/** accessor for controlling the sender of a logging object. The setSender message should be sent before the target receives a client message. */
- (NSString *)sender;
- (void)setSender:(NSString *)inSender;

/** accessor for controlling the facility of a logging object. The setFacility message should be sent before the target receives a client message. */
- (NSString *)facility;
- (void)setFacility:(NSString *)inFacility;

- (void)addHandler:(id <CLoggingHandler>)inHandler forEvents:(NSArray *)inEvents;
- (void)removeHandler:(id <CLoggingHandler>)inHandler;

/// Logging.
- (void)logLevel:(int)inLevel format:(NSString *)inFormat, ...;
- (void)logLevel:(int)inLevel dictionary:(NSDictionary *)inDictionary format:(NSString *)inFormat, ...;
- (void)logLevel:(int)inLevel fileFunctionLine:(SFileFunctionLine)inFileFunctionLine dictionary:(NSDictionary *)inDictionary format:(NSString *)inFormat, ...;

- (void)logError:(NSError *)inError;
- (void)logException:(NSException *)inException;

@end

#pragma mark -

@protocol CLoggingHandler <NSObject>

@optional
- (BOOL)handleLogging:(CLogging *)inLogging event:(NSString *)inEvent error:(NSError **)outError;

@end

#pragma mark -

#ifndef LOGGING
#define LOGGING 1
#endif

#if LOGGING == 1

#define Log_(level, ...) \
	do \
		{ \
		NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init]; \
		[[CLogging instance] logLevel:(level) fileFunctionLine:FileFunctionLine_() dictionary:FileFunctionLineDict_() format:__VA_ARGS__]; \
		[thePool release]; \
		} \
	while (0)

#define LogDict_(level, dict, ...) \
	do \
		{ \
		NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init]; \
		[[CLogging instance] logLevel:(level) fileFunctionLine:FileFunctionLine_() dictionary:dict format:__VA_ARGS__]; \
		[thePool release]; \
		} \
	while (0)

#define LogEmergency_(...) Log_(LoggingLevel_EMERG, __VA_ARGS__)
#define LogAlert_(...) Log_(LoggingLevel_ALERT, __VA_ARGS__)
#define LogCritical_(...) Log_(LoggingLevel_CRIT, __VA_ARGS__)
#define LogError_(...) Log_(LoggingLevel_ERR, __VA_ARGS__)
#define LogWarning_(...) Log_(LoggingLevel_WARNING, __VA_ARGS__)
#define LogNotice_(...) Log_(LoggingLevel_NOTICE, __VA_ARGS__)
#define LogInformation_(...) Log_(LoggingLevel_INFO, __VA_ARGS__)
#define LogDebug_(...) Log_(LoggingLevel_DEBUG, __VA_ARGS__)

#else

#define Log_(level, ...)
#define LogDict_(level, dict, ...)
#define LogEmergency_(...)
#define LogAlert_(...)
#define LogCritical_(...)
#define LogError_(...)
#define LogWarning_(...)
#define LogNotice_(...)
#define LogInformation_(...)
#define LogDebug_(...)

#endif /* LOGGING == 1 */

#pragma mark -

@interface NSError (NSException_LogExtensions)

- (void)log;

@end

@interface NSException (NSException_LogExtensions)

- (void)log;

@end


