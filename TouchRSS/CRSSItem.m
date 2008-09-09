//
//  CRSSItem.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CRSSItem.h"

@implementation CRSSItem

@synthesize identifier, title, link, description_, publicationDate;

- (void)dealloc
{
self.identifier = NULL;
self.title = NULL;
self.link = NULL;
self.description_ = NULL;
self.publicationDate = NULL;
//
[super dealloc];
}

@end
