//
//  CTileIdentifier.h
//  MapToy
//
//  Created by Jonathan Wight on 07/02/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLocation.h"
#import "Geometry.h"
#import "CMap.h"

@interface CTileIdentifier : NSObject <NSCopying> {
	NSInteger levelOfDetail;
	CIntegerPoint tilePoint;
	NSInteger tileSize;
	ETileType tileType;
	NSUInteger _hash;
}

@property (readonly, assign) NSInteger levelOfDetail;
@property (readonly, assign) CIntegerPoint tilePoint;
@property (readonly, assign) NSInteger tileSize;
@property (readonly, assign) ETileType tileType;
@property (readonly, nonatomic, retain) NSString *quadKey; 
@property (readonly, assign) CLLocationCoordinate2D location;

+ (CTileIdentifier *)tileIdentifierWithLevelOfDetail:(NSInteger)inLevelOfDetail tilePoint:(CIntegerPoint)inTilePoint tileSize:(NSInteger)inTileSize tileType:(ETileType)inTileType;

@end
