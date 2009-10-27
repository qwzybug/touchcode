//
//  CTemporaryData.h
//  Uploadr
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTemporaryData : NSObject {
	size_t dataLimit;
	id storage;
	NSURL *tempFileURL;
}

@property (readonly, assign) size_t dataLimit;
@property (readonly, retain) NSData *data;

- (id)initWithDataLimit:(size_t)inDataLimit;

- (BOOL)writeData:(NSData *)inData error:(NSError **)outError;
- (BOOL)copyDataToURL:(NSURL *)inURL error:(NSError **)outError;

@end
