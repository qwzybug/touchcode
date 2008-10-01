//
//  CGeoLineString.m
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright (c) 2008 Jonathan Wight
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
