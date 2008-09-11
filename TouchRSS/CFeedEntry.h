//
//  CRSSItem.h
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CFeed;

@interface CFeedEntry : NSObject {
	NSInteger rowID;
	CFeed *feed;
	NSString *identifier;
	NSString *title;
	NSURL *link;
	NSString *description_;
	NSDate *publicationDate;
}

@property (readonly, nonatomic, assign)	NSInteger rowID;
@property (readonly, nonatomic, assign)	CFeed *feed;
@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) NSURL *link;
@property (readwrite, nonatomic, retain) NSString *description_;
@property (readwrite, nonatomic, retain) NSDate *publicationDate;

- (id)initWithFeed:(CFeed *)inFeed rowID:(NSInteger)inRowID;
- (id)initWithFeed:(CFeed *)inFeed;
- (id)initWithFeed:(CFeed *)inFeed dictionary:(NSDictionary *)inDictionary;

- (BOOL)write:(NSError **)outError;

@end
