//
//  CMapObjectLayer.m
//  Nearby
//
//  Created by Jonathan Wight on 06/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CMapObjectLayer.h"


@implementation CMapObjectLayer

@synthesize coordinate;
@synthesize draggable;

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ ((%g, %g), (%g, %g))", [super description], self.position.x, self.position.y, self.coordinate.latitude, self.coordinate.longitude]);
}

@end
