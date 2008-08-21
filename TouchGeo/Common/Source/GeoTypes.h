//
//  GeoJSON.h
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float GeoScalar;
#define GeoScalarEpison_ 1.0e-6

static inline BOOL GeoScalarEqual(GeoScalar inOne, GeoScalar inTwo)
{
return(fabs(inOne - inTwo) <= GeoScalarEpison_);
}

#pragma mark -

typedef struct {
	GeoScalar v[6];
} SGeoBoundingBox;	

extern SGeoBoundingBox const GeoBoundingBoxZero;

extern BOOL GeoBoundingBoxEqual(SGeoBoundingBox inOne, SGeoBoundingBox inTwo);