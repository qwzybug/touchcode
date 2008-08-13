//
//  CGeoPoint.h
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoObject.h"

@interface CGeoPoint : CGeoObject {
	GeoScalar x, y, z;
}

@property (readwrite, assign) GeoScalar x, y, z;

- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY;
//- (id)initWithX:(GeoScalar)inX Y:(GeoScalar)inY Z:(GeoScalar)inZ;

- (id)initWithCoordinates:(NSArray *)inCoordinates;

@end
