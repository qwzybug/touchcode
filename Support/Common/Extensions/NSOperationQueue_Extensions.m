//
//  NSOperationQueue_Extensions.m
//  WebServiceEngine
//
//  Created by Jonathan Wight on 4/28/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "NSOperationQueue_Extensions.h"

@implementation NSOperationQueue (NSOperationQueue_Extensions)

- (void)addOperationRecursively:(NSOperation *)inOperation
{
[self addOperation:inOperation];

for (NSOperation *theDependency in inOperation.dependencies)
	{
	[self addOperationRecursively:theDependency];
	}
}

@end
