/*
 *  HSK_CFUtilities.h
 *  Handshake
 *
 *  Created by Ian Baird on 11/26/08.
 *  Copyright 2008 Skorpiostech, Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#if TARGET_OS_MAC == 1 && TARGET_OS_IPHONE == 0
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_MAC == 1 && TARGET_OS_IPHONE == 1
#import <CFNetwork/CFNetwork.h>
#endif

void CFStreamCreatePairWithUNIXSocketPair(CFAllocatorRef alloc, CFReadStreamRef *readStream, CFWriteStreamRef *writeStream);
CFIndex CFWriteStreamWriteFully(CFWriteStreamRef outputStream, const uint8_t* buffer, CFIndex length);

@interface NSStream (HSK_CFUtilities)

+ (void)createPairWithUNIXSocketPairWithInputStream:(NSInputStream **)inputStream outputStream:(NSOutputStream **)outputStream;

@end

@interface NSOutputStream (HSK_CFUtilities)

- (NSInteger)writeFully:(const uint8_t *)buffer maxLength:(NSUInteger)length;

@end
