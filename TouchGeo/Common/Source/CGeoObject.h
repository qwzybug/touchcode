//
//  CGeoObject.h
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeoTypes.h"

@interface CGeoObject : NSObject <NSCopying> {
	NSMutableDictionary *additionalMembers;
	SGeoBoundingBox boundingBox;
}

@property (readwrite, retain) NSMutableDictionary *additionalMembers;
@property (readwrite, assign) SGeoBoundingBox boundingBox;

+ (NSString *)geoTypeName;

- (BOOL)isEqual:(id)inObject;

- (BOOL)isValid:(NSError **)outError;

- (SGeoBoundingBox)computeMinimumBoundingBox;

#pragma mark -

+ (NSSet *)dictionaryKeys;
+ (id)objectFromDictionary:(NSDictionary *)inDictionary;
- (NSDictionary *)asDictionary;

@end
