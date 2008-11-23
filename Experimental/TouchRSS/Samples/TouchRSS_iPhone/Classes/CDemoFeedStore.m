//
//  CDemoFeedStore.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 11/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CDemoFeedStore.h"

static CDemoFeedStore *gInstance = NULL;

@implementation CDemoFeedStore

+ (CDemoFeedStore *)instance
{
if (gInstance == NULL)
	{
	gInstance = [[CFeedStore alloc] init];
	}
return(gInstance);
}

@end
