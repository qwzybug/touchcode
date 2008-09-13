//
//  CFeedDeserializer.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	FeedDictinaryType_Feed,
	FeedDictinaryType_Entry,
} ERSSFeedDictinaryType;

@protocol CFeedDeserializer <NSObject, NSFastEnumeration>

@property (readonly, nonatomic, retain) NSError *error;

- (id)initWithData:(NSData *)inData;

@end
