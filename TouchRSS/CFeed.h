//
//  CRSSChannel.h
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CFeedStore;
@class CFeedEntry;

@interface CFeed : NSObject {
	NSInteger rowID;
	CFeedStore *feedStore;
	NSString *title;
	NSURL *link;
	NSString *description_;
}

@property (readonly, nonatomic, assign)	NSInteger rowID;
@property (readonly, nonatomic, assign) CFeedStore *feedStore;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSURL *link;
@property (readwrite, nonatomic, retain) NSString *description_;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore dictionary:(NSDictionary *)inDictionary;
- (id)initWithFeedStore:(CFeedStore *)inFeedStore rowID:(NSInteger)inRowID;

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex;

- (BOOL)write:(NSError **)outError;

@end
