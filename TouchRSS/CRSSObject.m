//
//  CRSSObject.m
//  TouchRSS
//
//  Created by Jonathan Wight on 9/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CRSSObject.h"

@interface CRSSObject ()
@property (readwrite, nonatomic, assign) CRSSObject *parent;
@end

#pragma mark -

@implementation CRSSObject

@synthesize parent;

- (id)initWithParent:(CRSSObject *)inParent;
{
if ((self = [self init]) != NULL)
	{
	self.parent = inParent;
	}
return(self);
}

@end
