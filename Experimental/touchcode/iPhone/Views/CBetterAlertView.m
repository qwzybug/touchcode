//
//  CBetterAlertView.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CBetterAlertView.h"


@implementation CBetterAlertView

@synthesize userInfo;

- (void)dealloc
{
self.userInfo = NULL;
//
[super dealloc];
}

@end
