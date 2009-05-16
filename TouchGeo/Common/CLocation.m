//
//  CLocation.m
//  MapToy
//
//  Created by Jonathan Wight on 04/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CLocation.h"

@interface CLocation()
@property (readwrite, assign) CCoordinate coordinate; 
@end

@implementation CLocation

@synthesize coordinate;

- (id)initWithLatitude:(double)inLatitude longitude:(double)inLongitude
{
if ((self = [super init]) != nil)
	{
	CCoordinate theCoordinate = { .latitude = inLatitude, .longitude = inLongitude };
	self.coordinate = theCoordinate;
	}
return(self);
}

@end
