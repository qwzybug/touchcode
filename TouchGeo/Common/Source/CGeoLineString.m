//
//  CGeoLineString.m
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoLineString.h"

#import "CGeoPoint.h"

@implementation CGeoLineString

@synthesize points;

+ (NSString *)geoTypeName
{
return(@"LineString");
}

- (void)dealloc
{
self.points = NULL;
//
[super dealloc];
}

- (BOOL)isEqual:(id)inObject
{
return(
	[super isEqual:inObject]
	);
}

- (id)copyWithZone:(NSZone *)zone
{
CGeoLineString *theCopy = [super copyWithZone:zone];
theCopy.points = [[self.points copyWithZone:zone] autorelease];
return(theCopy);
}

#pragma mark -

+ (NSSet *)dictionaryKeys
{
return([[super dictionaryKeys] setByAddingObject:@"coordinates"]);
}

+ (id)objectFromDictionary:(NSDictionary *)inDictionary
{
CGeoLineString *theObject = [super objectFromDictionary:inDictionary];

NSMutableArray *thePoints = [NSMutableArray array];

NSArray *theCoordinates = [inDictionary objectForKey:@"coordinates"];
for (NSArray *thePointCoordinates in theCoordinates)
	{
	CGeoPoint *thePoint = [[[CGeoPoint alloc] initWithCoordinates:thePointCoordinates] autorelease];
	[thePoints addObject:thePoint];
	}
	
theObject.points = thePoints;

return(theObject);
}

- (NSDictionary *)asDictionary
{
}

#pragma mark -

- (BOOL)isRing
{
// TODO - what is the minimum # of points a ring should have? 0? 1? 2? 3?
return([[self.points objectAtIndex:0] isEqual:[self.points lastObject]]);
}

@end
