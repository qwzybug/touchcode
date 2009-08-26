//
//  CMapLayer.h
//  TouchCode
//
//  Created by Jonathan Wight on 05/22/08.
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
