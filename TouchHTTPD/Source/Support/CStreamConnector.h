//
//  CStreamConnector.h
//  StreamTest
//
//  Created by Jonathan Wight on 11/17/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CStreamConnectorDelegate;

@interface CStreamConnector : NSObject {
	NSInputStream *inputStream;
	NSOutputStream *outputStream;
	id <CStreamConnectorDelegate> delegate;
	NSInteger maximumBufferLength;
	NSMutableData *buffer;
	BOOL connected;
	BOOL expectingMoreInputFlag;
}

@property (readwrite, retain) NSInputStream *inputStream;
@property (readwrite, retain) NSOutputStream *outputStream;
@property (readwrite, assign) id <CStreamConnectorDelegate> delegate;
@property (readwrite, assign) NSInteger maximumBufferLength;
@property (readonly, assign) BOOL connected;

+ (id)streamConnectorWithInputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

- (id)initWithInputStream:(NSInputStream *)inInputStream outputStream:(NSOutputStream *)inOutputStream;

- (void)connect;

- (void)stream:(NSStream *)inStream handleEvent:(NSStreamEvent)inEventCode;

@end

#pragma mark -

@protocol CStreamConnectorDelegate

- (void)streamConnectorDidFinish:(CStreamConnector *)inStreamConnector;

@end