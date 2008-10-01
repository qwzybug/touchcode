//
//  CTileIdentifier.m
//  MapToy
//
//  Created by Jonathan Wight on 07/02/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTileIdentifier.h"

#import "VirtualEarthTileGeometry.h"

@implementation CTileIdentifier

@synthesize levelOfDetail;
@synthesize tilePoint;
@synthesize tileSize;
@synthesize tileType;
@dynamic quadKey; 
@dynamic location;

+ (CTileIdentifier *)tileIdentifierWithLevelOfDetail:(NSInteger)inLevelOfDetail tilePoint:(CIntegerPoint)inTilePoint tileSize:(NSInteger)inTileSize tileType:(ETileType)inTileType;
{
CTileIdentifier *theTileIdentifier = [[[self alloc] init] autorelease];
theTileIdentifier->levelOfDetail = inLevelOfDetail;
theTileIdentifier->tilePoint = inTilePoint;
theTileIdentifier->tileSize = inTileSize;
theTileIdentifier->tileType = inTileType;
return(theTileIdentifier);
}

- (NSUInteger)hash
{
if (_hash == 0)
	{
	NSString *theHashString = [NSString stringWithFormat:@"%d,(%d, %d),%d,%d", levelOfDetail, tilePoint.x, tilePoint.y, tileSize, tileType];
	_hash = [theHashString hash];
	}
return(_hash);
}

- (BOOL)isEqual:(id)inObject
{
if ([inObject isKindOfClass:[self class]] == NO)
	return(NO);
return([self hash] == [inObject hash]);
}

- (id)copyWithZone:(NSZone *)zone
{
CTileIdentifier *theCopy = [[[self class] alloc] init];
theCopy->levelOfDetail = levelOfDetail;
theCopy->tilePoint = tilePoint;
theCopy->tileSize = tileSize;
theCopy->tileType = tileType;
return(theCopy);
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (LOD: %d, XY: (%d, %d), SIZE: %d, HASH: 0x0%u)", [super description], self.levelOfDetail, self.tilePoint.x, self.tilePoint.y, self.tileSize, _hash]);
}

#pragma mark -

- (NSString *)quadKey
{
return(VETileXYToQuadKey(tilePoint, levelOfDetail));
}

- (CLLocationCoordinate2D)location
{
CIntegerPoint thePixelPoint = { .x = tilePoint.x * self.tileSize, .y = tilePoint.y * self.tileSize };

return(VEPixelXYToLatLon(thePixelPoint, self.levelOfDetail, self.tileSize));
}

@end
