//
//  CChunkWriter.h
//  FileServer
//
//  Created by Jonathan Wight on 12/30/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CChunkWriterDelegate;

// JIWTODO - to clear this up - it really _ought_ to be made into an NSOutputStream subclass. But right now quick & easy > best.
@interface CChunkWriter : NSObject {
	NSFileHandle *outputFile;
	BOOL moreChunksComing;
	NSInteger remainingChunkLength;
	NSMutableData *buffer;
	id <CChunkWriterDelegate> delegate;
}

@property (readwrite, retain) NSFileHandle *outputFile;
@property (readonly, assign) BOOL moreChunksComing;
@property (readonly, assign) NSInteger remainingChunkLength;
@property (readonly, retain) NSMutableData *buffer; // JIWTODO not currently used
@property (readwrite, assign) id <CChunkWriterDelegate> delegate;

- (void)writeData:(NSData *)inData;

@end

#pragma mark -

@protocol CChunkWriterDelegate <NSObject>
- (void)chunkWriterDidReachEOF:(CChunkWriter *)inChunkWriter;
@end
