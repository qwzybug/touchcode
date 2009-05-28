//
//  CMap.h
//  TouchCode
//
//  Created by Jonathan Wight on 05/01/08.
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

typedef enum {
	TileType_DeviceMobile = 0x01,
	TileType_ShadingHill,
	TileType_Aerial,
	TileType_Hybrid,
} ETileType;

@class CTileIdentifier;
@class CTileManager;

@interface CMap : NSObject {
	CGPoint tileOrigin;
	CGFloat levelOfDetailFloat;
	NSInteger tileSize;
	NSInteger mapSizeTiles;
	NSInteger mapSizePixels;
	NSInteger minLevelOfDetail;
	NSInteger maxLevelOfDetail;
	ETileType tileType;
	
	CTileManager *tileManager;
}

@property (readwrite, assign) CGPoint tileOrigin;
@property (readwrite, assign) NSInteger levelOfDetail;
@property (readwrite, assign) CGFloat levelOfDetailFloat;
@property (readonly, assign) NSInteger tileSize;
@property (readonly, assign) NSInteger mapSizeTiles;
@property (readonly, assign) NSInteger mapSizePixels;
@property (readonly, assign) NSInteger minLevelOfDetail;
@property (readonly, assign) NSInteger maxLevelOfDetail;
@property (readwrite, assign) ETileType tileType;
@property (readwrite, nonatomic, retain) CTileManager *tileManager;

- (CTileIdentifier *)tileXYToTileIdentifier:(CIntegerPoint)inTileXY;
- (CIntegerPoint)coordinateToPixelXY:(CLLocationCoordinate2D)inCoordinate levelOfDetail:(NSInteger)inLevelOfDetail;
- (CLLocationCoordinate2D)pixelXYToCoordinate:(CIntegerPoint)inPixelXL levelOfDetail:(NSInteger)inLevelOfDetail;
- (NSURL *)URLForTileIdentifier:(CTileIdentifier *)inTileIdentifier;
- (NSInteger)getMinimumLODToDisplayCircleAtCoordinate:(CLLocationCoordinate2D)inCoordinate ofDiameter:(double)inDiameterMeters withinPixels:(CGFloat)inPixels;

- (CGFloat)groundResolutionForCoordinate:(CLLocationCoordinate2D)inCoordinate;


@end
