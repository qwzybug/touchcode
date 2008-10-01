//
//  CMap.h
//  Nearby
//
//  Created by Jonathan Wight on 05/01/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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
