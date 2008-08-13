//
//  CGeoLineString.m
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoLineString.h"

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

- (id)initWithDictionary:(NSDictionary *)inDictionary
{
if ((self = [self initWithDictionary:inDictionary]) != NULL)
	{
	
	
	NSArray *theCoordinates = [inDictionary objectForKey:@"coordinates"];
	}
return(self);
}

#pragma mark -

- (BOOL)isRing
{
// TODO - what is the minimum # of points a ring should have? 0? 1? 2? 3?
return([[self.points objectAtIndex:0] isEqual:[self.points lastObject]]);
}

@end
