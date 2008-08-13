//
//  CGeoPoint.m
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoPoint.h"

@implementation CGeoPoint

@synthesize x, y, z;

+ (NSString *)geoTypeName
{
return(@"Point");
}

- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY;
{
if ((self = [super init]) != NULL)
	{
	x = inX;
	y = inY;
	}
return(self);
}

- (id)initWithCoordinates:(NSArray *)inCoordinates
{
if ((self = [super init]) != NULL)
	{
	self.x = [[inCoordinates objectAtIndex:0] doubleValue];
	self.y = [[inCoordinates objectAtIndex:1] doubleValue];
	if (inCoordinates.count == 3)
		{
		self.z = [[inCoordinates objectAtIndex:2] doubleValue];
		}
	}
return(self);
}

- (BOOL)isEqual:(id)inObject
{
return(
	[super isEqual:inObject]
	&& self.x == ((CGeoPoint *)inObject).x
	&& self.y == ((CGeoPoint *)inObject).y
	);
}

- (id)copyWithZone:(NSZone *)zone
{
CGeoPoint *theCopy = [super copyWithZone:zone];
theCopy.x = self.x;
theCopy.y = self.y;
return(theCopy);
}

#pragma mark -

+ (NSSet *)dictionaryKeys
{
return([[super dictionaryKeys] setByAddingObject:@"coordinates"]);
}

- (id)initWithDictionary:(NSDictionary *)inDictionary
{
if ((self = [self initWithDictionary:inDictionary]) != NULL)
	{
	NSArray *theCoordinates = [inDictionary objectForKey:@"coordinates"];
	self.x = [[theCoordinates objectAtIndex:0] doubleValue];
	self.y = [[theCoordinates objectAtIndex:1] doubleValue];
	if (theCoordinates.count == 3)
		{
		self.z = [[theCoordinates objectAtIndex:2] doubleValue];
		}
	}
return(self);
}


@end
