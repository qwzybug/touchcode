//
//  CRSSDeserializer.h
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <libxml/xmlreader.h>

#define kTouchRSSErrorDomain @"kTouchRSSErrorDomain"

@class CRSSFeed, CRSSChannel, CRSSItem;

@interface CRSSFeedDeserializer : NSObject <NSFastEnumeration> {
	xmlTextReaderPtr reader;
	NSError *error;
	CRSSFeed *currentFeed;
	CRSSChannel *currentChannel;
	CRSSItem *currentItem;
}

@property (readwrite, nonatomic, assign) xmlTextReaderPtr reader;
@property (readwrite, nonatomic, retain) NSError *error;

@end
