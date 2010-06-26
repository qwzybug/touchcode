//
//  CGeoPoint.m
//  TouchCode
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CGeoPoint.h"

@implementation CGeoPoint

@synthesize x, y;

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
