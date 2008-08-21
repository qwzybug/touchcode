//
//  GeoJSON.m
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "GeoTypes.h"


SGeoBoundingBox const GeoBoundingBoxZero = { .v = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } };

BOOL GeoBoundingBoxEqual(SGeoBoundingBox inOne, SGeoBoundingBox inTwo)
{
return(memcmp(&inOne, &inTwo, sizeof(inOne)) == 0
	|| (
		GeoScalarEqual(inOne.v[0], inTwo.v[0])
		&& GeoScalarEqual(inOne.v[1], inTwo.v[1])
		&& GeoScalarEqual(inOne.v[2], inTwo.v[2])
		&& GeoScalarEqual(inOne.v[3], inTwo.v[3])
		&& GeoScalarEqual(inOne.v[4], inTwo.v[4])
		&& GeoScalarEqual(inOne.v[5], inTwo.v[5])
		));
}
