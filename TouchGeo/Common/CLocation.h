//
//  CLocation.h
//  MapToy
//
//  Created by Jonathan Wight on 04/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !TARGET_OS_IPHONE
#define CLLocation CLocation
#define CLLocationCoordinate2D CCoordinate
#else
#import <CoreLocation/CoreLocation.h>
#endif

struct CCoordinate {
	double latitude;
	double longitude;
};
typedef struct CCoordinate CCoordinate;

@interface CLocation : NSObject {
	CCoordinate coordinate;
}

@property (readonly, assign) CCoordinate coordinate; 

- (id)initWithLatitude:(double)inLatitude longitude:(double)inLongitude;

@end
