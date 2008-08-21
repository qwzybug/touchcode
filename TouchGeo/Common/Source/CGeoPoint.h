//
//  CGeoPoint.h
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoObject.h"

@interface CGeoPoint : CGeoObject {
	GeoScalar x, y, z;
}

@property (readwrite, assign) GeoScalar x, y, z;
@property (readonly, assign) BOOL zDefined;

- (id)init;
- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY Z:(GeoScalar)inZ;
- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY;
- (id)initWithCoordinates:(NSArray *)inCoordinates;

@end
