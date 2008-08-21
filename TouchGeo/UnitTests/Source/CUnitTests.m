//
//  CUnitTests.m
//  TouchGeo
//
//  Created by Jonathan Wight on 08/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CUnitTests.h"

#import "GeoTypes.h"

@implementation CUnitTests

- (void)testScalars
{
STAssertTrue(GeoScalarEqual(1.0, 1.0), NULL);
STAssertFalse(GeoScalarEqual(1.0, 0.0), NULL);
STAssertTrue(GeoScalarEqual(1.0 + GeoScalarEpison_, 1.0), NULL);
STAssertFalse(GeoScalarEqual(1.0 + GeoScalarEpison_ * 1.1, 1.0), NULL);
}

@end
