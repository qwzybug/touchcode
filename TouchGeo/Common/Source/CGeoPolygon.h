//
//  CGeoPolygon.h
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CGeoObject.h"

@class CGeoLineString;

@interface CGeoPolygon : CGeoObject {
	CGeoLineString *exteriorRing;
	NSMutableArray *interiorRings;
}

@property (readwrite, retain) CGeoLineString *exteriorRing;
@property (readwrite, retain) NSMutableArray *interiorRings;

@end
