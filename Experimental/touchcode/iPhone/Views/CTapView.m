//
//  CTapView.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTapView.h"

@implementation CTapView

@synthesize target;
@synthesize action;

- (void)dealloc
{
self.target = NULL;
self.action = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
if (self.action && [self.target respondsToSelector:self.action])
	[self.target performSelector:self.action withObject:self];
}

@end
