//
//  CMap.m
//  Nearby
//
//  Created by Jonathan Wight on 05/01/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CMap.h"

#import "CLocation.h"
#import "VirtualEarthTileGeometry.h"
#import "CTileIdentifier.h"
#import "CTileManager.h"

@interface CMap ()
@end

#pragma mark -

@implementation CMap

@dynamic tileOrigin;
@dynamic levelOfDetail;
@dynamic levelOfDetailFloat;
@synthesize tileSize;
@synthesize mapSizeTiles;
@synthesize mapSizePixels;
@synthesize minLevelOfDetail;
@synthesize maxLevelOfDetail;
@dynamic tileType;
@synthesize tileManager;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	tileOrigin = CGPointMake(0, 0);
	tileSize = 128;
	minLevelOfDetail = 2;
	maxLevelOfDetail = 18;
	self.levelOfDetailFloat = minLevelOfDetail;
	tileType = TileType_ShadingHill;
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TileType"] != NULL)
		tileType = [[NSUserDefaults standardUserDefaults] integerForKey:@"TileType"];
	
	self.tileManager = [[[CTileManager alloc] initWithMap:self] autorelease];
	}
return(self);
}

- (void)dealloc
{
self.tileManager = NULL;

[super dealloc];
}

- (CGPoint)tileOrigin
{
return(tileOrigin);
}

- (void)setTileOrigin:(CGPoint)inTileOrigin
{
if (tileOrigin.x != inTileOrigin.x || tileOrigin.y != inTileOrigin.y)
	{
	tileOrigin = inTileOrigin;
	}
}

- (NSInteger)levelOfDetail
{
return(floor(self.levelOfDetailFloat));
}

- (void)setLevelOfDetail:(NSInteger)inLevelOfDetail
{
self.levelOfDetailFloat = inLevelOfDetail;
}

- (CGFloat)levelOfDetailFloat
{
return(levelOfDetailFloat);
}

- (void)setLevelOfDetailFloat:(CGFloat)inLevelOfDetailFloat
{
NSAssert(self.tileSize != 0, @"TileSize should not be 0");

levelOfDetailFloat = CLIP(inLevelOfDetailFloat, self.minLevelOfDetail, self.maxLevelOfDetail);

mapSizeTiles = VEMapSizeTiles(self.levelOfDetail);
mapSizePixels = VEMapSizePixels(self.levelOfDetail, self.tileSize);
}

- (CTileIdentifier *)tileXYToTileIdentifier:(CIntegerPoint)inTileXY
{
//NSString *theQuadKey = VETileXYToQuadKey(inTileXY, self.levelOfDetail);
//NSString *theTileIdentifier = [NSString stringWithFormat:@"%@,%d,%@", self.tileType, self.tileSize, theQuadKey];

return([CTileIdentifier tileIdentifierWithLevelOfDetail:self.levelOfDetail tilePoint:inTileXY tileSize:self.tileSize tileType:self.tileType]);
}


- (ETileType)tileType
{
return tileType;
}

- (void)setTileType:(ETileType)inTileType
{
tileType = inTileType;
[[NSUserDefaults standardUserDefaults] setInteger:tileType forKey:@"TileType"];
}

#pragma mark -

- (CIntegerPoint)coordinateToPixelXY:(CLLocationCoordinate2D)inCoordinate levelOfDetail:(NSInteger)inLevelOfDetail
{
return(VELatLongToPixelXY(inCoordinate, inLevelOfDetail, self.tileSize));
}

- (CLLocationCoordinate2D)pixelXYToCoordinate:(CIntegerPoint)inPixelXY levelOfDetail:(NSInteger)inLevelOfDetail
{
return(VEPixelXYToLatLon(inPixelXY, inLevelOfDetail, self.tileSize));
}

- (NSURL *)URLForTileIdentifier:(CTileIdentifier *)inTileIdentifier
{
// TODO -- cache all of this!
// TODO - we need to make sure generation is updated!!!
int theGeneration = 137;
NSInteger theTileSize = inTileIdentifier.tileSize;
NSString *theQuadKey = inTileIdentifier.quadKey;

unichar theQuadFinalChar = [theQuadKey characterAtIndex:[theQuadKey length] - 1];
NSString *theURLString = NULL;

NSString *theTileType = NULL;
switch (self.tileType)
	{
	case TileType_DeviceMobile:
		{
		theTileType = @"device.mobile";
		theURLString = [NSString stringWithFormat:@"http://t%c.tiles.virtualearth.net/tiles/cmd/mobileTile?g=%d&a=%@&size=%d&base=r&baseatt=%@&fmt=png", theQuadFinalChar, theGeneration, theQuadKey, theTileSize, theTileType];
		}
		break;
	case TileType_ShadingHill:
		{
		theTileType = @"shading.hill";
		theURLString = [NSString stringWithFormat:@"http://t%c.tiles.virtualearth.net/tiles/cmd/mobileTile?g=%d&a=%@&size=%d&base=r&baseatt=%@&fmt=png", theQuadFinalChar, theGeneration, theQuadKey, theTileSize, theTileType];
		}
		break;
	case TileType_Aerial:
		{
		theTileType = @"shading.hill";
		theURLString = [NSString stringWithFormat:@"http://t%c.tiles.virtualearth.net/tiles/cmd/mobileTile?g=%d&a=%@&size=%d&base=a&baseatt=%@&fmt=png", theQuadFinalChar, theGeneration, theQuadKey, theTileSize, theTileType];
		}
		break;
	case TileType_Hybrid:
		{
		theTileType = @"shading.hill";
		theURLString = [NSString stringWithFormat:@"http://t%c.tiles.virtualearth.net/tiles/cmd/mobileTile?g=%d&a=%@&size=%d&base=h&baseatt=%@&fmt=png", theQuadFinalChar, theGeneration, theQuadKey, theTileSize, theTileType];
		}
		break;
	}

NSURL *theURL = [NSURL URLWithString:theURLString];
return(theURL);
}

- (NSInteger)getMinimumLODToDisplayCircleAtCoordinate:(CLLocationCoordinate2D)inCoordinate ofDiameter:(double)inDiameterMeters withinPixels:(CGFloat)inPixels
{
for (NSInteger theLOD = self.maxLevelOfDetail; theLOD >= self.minLevelOfDetail; --theLOD)
	{
	const double theResolution = VEGroundResolution(inCoordinate.latitude, theLOD, self.tileSize) * inPixels;
	if (theResolution >= inDiameterMeters)
		return(theLOD);
	}

return(self.maxLevelOfDetail);
}

- (CGFloat)groundResolutionForCoordinate:(CLLocationCoordinate2D)inCoordinate
{
return(VEGroundResolution(inCoordinate.latitude, self.levelOfDetail, self.tileSize));
}

@end
