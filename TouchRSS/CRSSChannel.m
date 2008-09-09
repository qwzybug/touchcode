//
//  CRSSChannel.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CRSSChannel.h"

@implementation CRSSChannel

@synthesize title, link, description_;

- (void)dealloc
{
self.title = NULL;
self.link = NULL;
self.description_ = NULL;
//
[super dealloc];
}

@end
