//
//  CGeoPoint.m
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoPoint.h"

@implementation CGeoPoint

@synthesize x, y;
@dynamic z;
@dynamic zDefined;

+ (NSString *)geoTypeName
{
return(@"Point");
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.x = 0.0;
	self.y = 0.0;
	self.z = NAN;
	}
return(self);
}

- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY Z:(GeoScalar)inZ;
{
if ((self = [self init]) != NULL)
	{
	x = inX;
	y = inY;
	z = inZ;
	}
return(self);
}

- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY
{
if ((self = [self init]) != NULL)
	{
	x = inX;
	y = inY;
	}
return(self);
}

- (id)initWithCoordinates:(NSArray *)inCoordinates
{
if ((self = [self init]) != NULL)
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

- (GeoScalar)z
{
NSAssert(self.zDefined == NO, @"Should not get z attribute if z is NAN. Use isZDefined property to test.");
return(z);
}

- (void)setZ:(GeoScalar)inZ
{
z = inZ;
}

- (BOOL)zDefined
{
return(!isnan(z));
}

- (BOOL)isEqual:(id)inObject
{
return(
	[super isEqual:inObject]
	&& self.x == ((CGeoPoint *)inObject).x
	&& self.y == ((CGeoPoint *)inObject).y
	&& (self.zDefined == ((CGeoPoint *)inObject).zDefined)
	&& (self.zDefined && self.z == ((CGeoPoint *)inObject).z)
	);
}

- (id)copyWithZone:(NSZone *)zone
{
CGeoPoint *theCopy = [super copyWithZone:zone];
theCopy.x = self.x;
theCopy.y = self.y;
if (self.zDefined)
	theCopy.z = self.z;
return(theCopy);
}

- (NSString *)description
{
if (self.zDefined == NO)
	return([NSString stringWithFormat:@"%@ (x:%g, y:%g)", [super description], self.x, self.y]);
else
	return([NSString stringWithFormat:@"%@ (x:%g, y:%g, z:%g)", [super description], self.x, self.y, self.z]);
}

#pragma mark -

+ (NSSet *)dictionaryKeys
{
return([[super dictionaryKeys] setByAddingObject:@"coordinates"]);
}

+ (id)objectFromDictionary:(NSDictionary *)inDictionary
{
CGeoPoint *theObject = [super objectFromDictionary:inDictionary];

NSArray *theCoordinates = [inDictionary objectForKey:@"coordinates"];
theObject.x = [[theCoordinates objectAtIndex:0] doubleValue];
theObject.y = [[theCoordinates objectAtIndex:1] doubleValue];
if (theCoordinates.count == 3)
	{
	theObject.z = [[theCoordinates objectAtIndex:2] doubleValue];
	}
return(theObject);
}

- (NSDictionary *)asDictionary
{
NSArray *theCoordinates = [NSArray arrayWithObjects:
	[NSNumber numberWithDouble:self.x],
	[NSNumber numberWithDouble:self.y],
	self.zDefined ? [NSNumber numberWithDouble:self.z] : NULL,
	NULL];

NSMutableDictionary *theSelfDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	theCoordinates, @"coordinates",
	NULL];

[theSelfDictionary addEntriesFromDictionary:[super asDictionary]];

return(theSelfDictionary);
}

@end
