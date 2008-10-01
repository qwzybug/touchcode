//
//  CNewMapMosaicLayer.h
//  MapToy
//
//  Created by Jonathan Wight on 05/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Geometry.h"
#import "CLocation.h"

@class CMap;
@class CMarkerLayer;
@class CMapObjectLayer;
@class CObjectPool;

@interface CMapLayer : CALayer {
	CMap *map;
	CALayer *markerContainerLayer;
	NSMutableDictionary *tileLayers;
	NSMutableArray *mapObjectLayers;
	CObjectPool *layerPool;
}

// TODO most of these properties need to be made private
@property (readwrite, nonatomic, retain) CMap *map;
@property (readwrite, nonatomic, retain) CALayer *markerContainerLayer;
@property (readwrite, nonatomic, retain) NSMutableDictionary *tileLayers;
@property (readwrite, nonatomic, retain) NSMutableArray *mapObjectLayers;
@property (readwrite, nonatomic, retain) CObjectPool *layerPool;

- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)inCoordinate;
- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)inPoint;
- (CLLocationCoordinate2D)centerCoordinate;

- (void)addMarker:(CMarkerLayer *)inMarker;
- (void)removeMarker:(CMarkerLayer *)inMarker;

- (void)scrollBy:(CGPoint)inDelta;
- (void)scrollToPoint:(CGPoint)inPoint;
- (void)scrollToCenterPoint:(CGPoint)inPoint;

- (void)scrollToCenterCoordinate:(CLLocationCoordinate2D)inCoordinate;

- (void)repositionLayers;

@end
