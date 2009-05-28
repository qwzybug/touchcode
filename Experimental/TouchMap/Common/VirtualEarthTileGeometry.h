//
//  VirtualEarthTileGeometry.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import <Foundation/Foundation.h>

#import "Geometry.h"
#import "CLocation.h"

#define kMinLevelOfDetail 2
#define kMaxLevelOfDetail 18
#define kEarthRadius 6378137.0
#define kMinLatitude -85.05112878
#define kMaxLatitude 85.05112878
#define kMinLongitude -180.0
#define kMaxLongitude 180.0
//#define kTileSize 128 // HERE

#define CLIP(X, min, max) MIN(MAX(min, X), max)

/** Determines the map width and height (in tiles) at a specified level of detail. */
static inline NSUInteger VEMapSizeTiles(int inLevelOfDetail)
{
return((NSUInteger)1 << inLevelOfDetail);
}

/** Determines the map width and height (in pixels) at a specified level of detail. */
static inline NSUInteger VEMapSizePixels(int inLevelOfDetail, int inTileSize)
{
return((NSUInteger)inTileSize << inLevelOfDetail);
}

/** Determines the ground resolution (in meters per pixel) at a specified latitude and level of detail. */
static inline double VEGroundResolution(double latitude, int levelOfDetail, int inTileSize)
{
latitude = CLIP(latitude, kMinLatitude, kMaxLatitude);
return cos(latitude * M_PI / 180.0) * 2.0 * M_PI * kEarthRadius / (float)VEMapSizePixels(levelOfDetail, inTileSize);
}

/** Determines the map scale at a specified latitude (in degrees), level of detail, and screen resolution. */
static inline double VEMapScale(double latitude, int levelOfDetail, int screenDpi, int inTileSize)
{
return VEGroundResolution(latitude, levelOfDetail, inTileSize) * screenDpi / 0.0254;
}

/** Scales a pixel location to a new level of detail **/
static inline CIntegerPoint VEScalePixelXY(CIntegerPoint inPixelXY, int inLevelOfDetail, int inDesiredLevelOfDetail)
{
int theLevelOfDetailDifference = inDesiredLevelOfDetail - inLevelOfDetail;

if (theLevelOfDetailDifference == 0)
	return(inPixelXY);
else
	{
	double theFactor = pow(2, theLevelOfDetailDifference);
	return(CIntegerPointMake(inPixelXY.x * theFactor, inPixelXY.y * theFactor));
	}
}

/** Converts a pixel location to coordinates at a given level of detail **/
static inline CLLocationCoordinate2D VEPixelXYToLatLon(CIntegerPoint inPixelXY, int inLevelOfDetail, int inTileSize)
{
const NSUInteger theMapSize = VEMapSizePixels(inLevelOfDetail, inTileSize);

double y = inPixelXY.y;
y = pow(M_E, (0.5 - ((y - 0.5) / theMapSize)) * (4.0 * M_PI));
y = -(1.0 - y) / (1.0 + y);
y = asin(y) / (M_PI / 180);

CLLocationCoordinate2D theCoordinate = {
	.longitude = fmod((inPixelXY.x - 0.5) / theMapSize * 360.0, 360.0) - 180.0,
	.latitude = y
	};
	
theCoordinate.latitude = CLIP(theCoordinate.latitude, kMinLatitude, kMaxLatitude);
theCoordinate.longitude = CLIP(theCoordinate.longitude, kMinLongitude, kMaxLongitude);

return(theCoordinate);
}

/** Converts a point from latitude/longitude WGS-84 coordinates (in degrees) into pixel XY coordinates at a specified level of detail. */
static inline CIntegerPoint VELatLongToPixelXY(CLLocationCoordinate2D inCoordinate, int inLevelOfDetail, int inTileSize)
{
const double theLatitude = CLIP(inCoordinate.latitude, kMinLatitude, kMaxLatitude);
const double theLongitude = CLIP(inCoordinate.longitude, kMinLongitude, kMaxLongitude);

const double x = (theLongitude + 180.0) / 360.0; 
const double sinLatitude = sin(theLatitude * M_PI / 180.0);
const double y = 0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * M_PI);

const NSUInteger theMapSize = VEMapSizePixels(inLevelOfDetail, inTileSize);
const CIntegerPoint thePixelXY = {
	.x = CLIP(x * theMapSize + 0.5, 0.0, theMapSize - 1.0),
	.y = CLIP(y * theMapSize + 0.5, 0.0, theMapSize - 1.0)
	};
return(thePixelXY);
}

/** Converts pixel XY coordinates into tile XY coordinates. */
static inline CIntegerPoint VEPixelXYToTileXY(CIntegerPoint inPoint, int inTileSize)
{
inPoint.x /= inTileSize;
inPoint.y /= inTileSize;
return(inPoint);
}

static inline CIntegerPoint VETileXYToPixelXY(CIntegerPoint inPoint, int inTileSize)
{
inPoint.x *= inTileSize;
inPoint.y *= inTileSize;
return(inPoint);
}

/** Generates string key for a tile at given coordinate and level of detail **/
static inline NSString *VETileXYToQuadKey(CIntegerPoint inTile, int inLevelOfDetail)
{
NSMutableString *quadKey = [NSMutableString string];
for (int i = inLevelOfDetail; i > 0; i--)
	{
	char digit = '0';
	const int mask = 1 << (i - 1);
	if ((inTile.x & mask) != 0)
		{
		digit++;
		}
	if ((inTile.y & mask) != 0)
		{
		digit++;
		digit++;
		}
	[quadKey appendFormat:@"%C", digit];
	}
return(quadKey);
}


