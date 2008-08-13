//
//  CGeoObject.m
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoObject.h"

@implementation CGeoObject

@dynamic additionalMembers;
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

- (id)initWithDictionary:(NSDictionary *)inDictionary
{
if ((self = [self init]) != NULL)
	{
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
	self.boundingBox = theBoundingBox;

	//
	NSMutableDictionary *theAdditionalMembers = [NSMutableDictionary dictionary];
	for (NSString *theKey in inDictionary)
		{
		if ([[[self class] dictionaryKeys] containsObject:theKey] == NO)
			{
			[theAdditionalMembers setObject:[inDictionary objectForKey:theKey] forKey:theKey];
			}
		}
	self.additionalMembers = theAdditionalMembers;
	}
return(self);
}

- (NSDictionary *)asDictionary
{
return(NULL);
}

@end

