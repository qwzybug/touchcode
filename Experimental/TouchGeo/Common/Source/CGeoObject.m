//
//  CGeoObject.m
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

#import "CGeoObject.h"

@implementation CGeoObject

@synthesize additionalMembers;
@synthesize boundingBox;

+ (NSString *)geoTypeName
{
return(NULL);
}

- (void)dealloc
{
self.additionalMembers = NULL;
//	
[super dealloc];
}

- (BOOL)isEqual:(id)inObject
{
return(
	self == inObject
	|| ([self class] == [inObject class] && GeoBoundingBoxEqual(self.boundingBox, ((CGeoObject *)inObject).boundingBox) && [self.additionalMembers isEqual:((CGeoObject *)inObject).additionalMembers])
	);
}

- (id)copyWithZone:(NSZone *)zone
{
CGeoObject *theCopy = [[[self class] allocWithZone:zone] init];
theCopy.additionalMembers = [[self.additionalMembers copyWithZone:zone] autorelease];;
theCopy.boundingBox = self.boundingBox;
return(theCopy);
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (%@)", [super description], self.additionalMembers]);
}

#pragma mark -

- (BOOL)isValid:(NSError **)outError
{
#pragma unused (outError)
return(YES);
}

- (SGeoBoundingBox)computeMinimumBoundingBox
{
NSAssert(NO, @"Abstract CGeoObject cannot produce a bounding box.");
return(GeoBoundingBoxZero);
}

#pragma mark -

+ (NSSet *)dictionaryKeys
{
return([NSSet setWithObjects:@"type", @"bbox", NULL]);
}

+ (id)objectFromDictionary:(NSDictionary *)inDictionary
{
CGeoObject *theObject = [[[[self class] alloc] init] autorelease];

NSArray *theBoundingBoxValues = [inDictionary objectForKey:@"bbox"];
SGeoBoundingBox theBoundingBox = {
	.v = {
		[[theBoundingBoxValues objectAtIndex:0] doubleValue],
		[[theBoundingBoxValues objectAtIndex:1] doubleValue],
		[[theBoundingBoxValues objectAtIndex:2] doubleValue],
		[[theBoundingBoxValues objectAtIndex:3] doubleValue],
		theBoundingBoxValues.count == 6 ? [[theBoundingBoxValues objectAtIndex:4] doubleValue] : 0.0,
		theBoundingBoxValues.count == 6 ? [[theBoundingBoxValues objectAtIndex:5] doubleValue] : 0.0,
		}};
theObject.boundingBox = theBoundingBox;

//
NSMutableDictionary *theAdditionalMembers = [NSMutableDictionary dictionary];
for (NSString *theKey in inDictionary)
	{
	if ([[[self class] dictionaryKeys] containsObject:theKey] == NO)
		{
		[theAdditionalMembers setObject:[inDictionary objectForKey:theKey] forKey:theKey];
		}
	}
theObject.additionalMembers = theAdditionalMembers;

return(theObject);
}

- (NSDictionary *)asDictionary
{
NSMutableDictionary *theDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	[[self class] geoTypeName], @"type",
	NULL
	];

if (self.additionalMembers)
	{
	[theDictionary addEntriesFromDictionary:self.additionalMembers];
	}

return(theDictionary);
}

@end

