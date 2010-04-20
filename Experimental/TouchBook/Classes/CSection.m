//
//  CSection.m
//  TouchBook
//
//  Created by Jonathan Wight on 02/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CSection.h"


@implementation CSection

@synthesize URL;

- (id)initWithURL:(NSURL *)inURL
{
if ((self = [super init]) != NULL)
	{
	URL = [inURL retain];
	}
return(self);
}

@end
