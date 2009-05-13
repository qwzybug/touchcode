//
//  CMultiStream.h
//  StreamTest
//
//  Created by Jonathan Wight on 11/17/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMultiInputStream : NSInputStream {
	id delegate;
	NSRunLoop *runLoop;
	NSString *mode;
	NSArray *streams;
	NSInputStream *currentStream;
	NSEnumerator *enumerator;
}

@property (readwrite, retain) id delegate;
@property (readonly, retain) NSArray *streams;

- (id)initWithStreams:(NSArray *)inStreams;

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;
- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len;
- (BOOL)hasBytesAvailable;

@end
