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
@class CObjectTranscoder;

@interface CFeed : NSObject {
	NSInteger rowID;
	CFeedStore *feedStore;
	NSString *title;
	NSURL *link;
	NSString *description_;
	NSDate *lastChecked;
}

@property (readonly, nonatomic, assign)	NSInteger rowID;
@property (readonly, nonatomic, assign) CFeedStore *feedStore;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSURL *link;
@property (readwrite, nonatomic, retain) NSString *description_;
@property (readwrite, nonatomic, retain) NSDate *lastChecked;

+ (CObjectTranscoder *)objectTranscoder;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore;
- (id)initWithFeedStore:(CFeedStore *)inFeedStore rowID:(NSInteger)inRowID;

- (CFeedEntry *)entryAtIndex:(NSInteger)inIndex;
- (CFeedEntry *)entryForIdentifier:(NSString *)inIdentifier;

- (BOOL)read:(NSError **)outError;
- (BOOL)write:(NSError **)outError;

@end
