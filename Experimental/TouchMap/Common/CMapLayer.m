//
//  CMapLayer.m
//  MapToy
//
//  Created by Jonathan Wight on 05/22/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CMapLayer.h"

#import "CALayer_Extensions.h"
#import "CTileManager.h"
#import "CMap.h"
#import "CMarkerLayer.h"
#import "CTileIdentifier.h"
#import "VirtualEarthTileGeometry.h"
#import "CObjectPool.h"

static const NSString *kMapLevelOfDetailModifiedContext = @"kMapLevelOfDetailModifiedContext";
static const NSString *kMapTileOriginModifiedContext = @"kMapTileOriginModifiedContext";
static const NSString *kMapTileTypeModifiedContext = @"kMapTileTypeModifiedContext";

#define kRemoveOldLayers 0

@interface CMapLayer ()
- (NSSet *)tilesToBeDisplayed;
- (void)updateTileLayers;
- (void)repositionLayers;
@end

#pragma mark -

@implementation CMapLayer

@dynamic map;
@synthesize markerContainerLayer;
@synthesize tileLayers;
@synthesize mapObjectLayers;
@synthesize layerPool;

- (id)init
{
if ((self = [super init]) != nil)
	{
	self.markerContainerLayer = [CALayer layer];

	self.layerPool = [[[CObjectPool alloc] initWithObjectClass:[CMapObjectLayer class] creationSelector:@selector(layer)] autorelease];

	[self addSublayer:self.markerContainerLayer];
	self.tileLayers = [NSMutableDictionary dictionary];
	self.mapObjectLayers = [NSMutableSet set];
	
	UIImage *theImage = [UIImage imageNamed:@"MSVELogo.png"];
	CGSize theSize = theImage.size;
	const CGRect theBounds = { .origin = CGPointZero, .size = theSize };
	CALayer *theAttributionLayer = [CALayer layer];
	theAttributionLayer.bounds = theBounds;
	theAttributionLayer.anchorPoint = CGPointZero;
	theAttributionLayer.contents = (id)theImage.CGImage;
	theAttributionLayer.position = CGPointMake(0, 380);
	[self addSublayer:theAttributionLayer];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tileManagerDidReceiveData:) name:@"CTileManagerReceivedData" object:self.map.tileManager];
	}
return(self);
}

- (void)dealloc
{
[[NSNotificationCenter defaultCenter] removeObserver:self];

self.map = NULL;
self.markerContainerLayer = NULL;
self.mapObjectLayers = NULL;
self.layerPool = NULL;
//
[super dealloc];
}

#pragma mark -

- (CMap *)map
{
return(map); 
}

- (void)setMap:(CMap *)inMap
{
if (map != inMap)
	{
	if (map != NULL)
		{
		[map removeObserver:self forKeyPath:@"levelOfDetail"];
		[map removeObserver:self forKeyPath:@"tileOrigin"];

		[map release];
		map = NULL;
		}
	if (inMap != NULL)
		{
		map = [inMap retain];

		[self.map addObserver:self forKeyPath:@"levelOfDetail" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:(void *)kMapLevelOfDetailModifiedContext];
		[self.map addObserver:self forKeyPath:@"tileOrigin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:(void *)kMapTileOriginModifiedContext];
		[self.map addObserver:self forKeyPath:@"tileType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:(void *)kMapTileTypeModifiedContext];

		CLLocationCoordinate2D theCoordinate = { 0, 0 };
		[self scrollToCenterCoordinate:theCoordinate];

		[self setNeedsDisplay];
		}
    }
}

#pragma mark -

- (void)layoutSublayers
{
[self updateTileLayers];
}

#pragma mark -

- (NSSet *)tilesToBeDisplayed
{
const CGRect theBounds = self.bounds;

if (CGRectGetWidth(theBounds) == 0.0 || CGRectGetHeight(theBounds) == 0.0)
	return([NSDictionary dictionary]);

const NSInteger theTileSize = self.map.tileSize;
const NSInteger theMapSizeTiles = self.map.mapSizeTiles;
const NSInteger theMapSizePixels = self.map.mapSizePixels;

const CGPoint theTileOrigin = self.map.tileOrigin;
const CGRect theRect = CGRectOffset(theBounds, theTileOrigin.x, theTileOrigin.y);
const CGFloat MIN_X = floor(CGRectGetMinX(theRect) / theTileSize) * theTileSize;
const CGFloat MAX_X = ceil(CGRectGetMaxX(theRect) / theTileSize) * theTileSize;
const CGFloat MIN_Y = floor(CGRectGetMinY(theRect) / theTileSize) * theTileSize;
const CGFloat MAX_Y = ceil(CGRectGetMaxY(theRect) / theTileSize) * theTileSize;

// Create a list of all tiles pixel positions.
NSMutableSet *theTileXYsByTileIdentifier = [NSMutableSet set];
CGPoint thePoint;
for (thePoint.y = MIN_Y; thePoint.y <= MAX_Y; thePoint.y += theTileSize)
	{
	for (thePoint.x = MIN_X; thePoint.x <= MAX_X; thePoint.x += theTileSize)
		{
		if (thePoint.y < 0 || thePoint.y >= theMapSizePixels)
			continue;

		const CIntegerPoint theTileXY = {
			.x = ((int)floor(thePoint.x / theTileSize) + theMapSizeTiles) % theMapSizeTiles,
			.y = ((int)floor(thePoint.y / theTileSize) + theMapSizeTiles) % theMapSizeTiles,
			};

		CTileIdentifier *theTileIdentifier = [self.map tileXYToTileIdentifier:theTileXY];
		[theTileXYsByTileIdentifier addObject:theTileIdentifier];
		}
	}
return(theTileXYsByTileIdentifier);
}

- (void)updateTileLayers
{
NSSet *theTileXYsByTileIdentifier = [self tilesToBeDisplayed];

// #############################################################################

// TODO this is NOT working.
#if kRemoveOldLayers

NSMutableSet *theNotNeededTiles = [NSMutableSet setWithArray:self.tileLayers.allKeys];
[theNotNeededTiles minusSet:theTileXYsByTileIdentifier];

// Remove all the tiles that have fallen outside of the screen.
for (CTileIdentifier *theTileIdentifier in theNotNeededTiles)
	{
	CMapObjectLayer *theTileLayer = [self.tileLayers objectForKey:theTileIdentifier];
	
	[theTileLayer retain];
	
	[theTileLayer removeFromSuperlayer];
	[self.mapObjectLayers removeObject:theTileLayer];
	[self.tileLayers removeObjectForKey:theTileIdentifier];

	[self.layerPool returnObjectToPool:theTileLayer];

	[theTileLayer release];
	}

#endif

// #############################################################################

const NSInteger theTileSize = self.map.tileSize;

NSMutableSet *theNewTiles = [NSMutableSet set];

for (CTileIdentifier *theTileIdentifier in theTileXYsByTileIdentifier)
	{
	CMapObjectLayer *theTileLayer = [self.tileLayers objectForKey:theTileIdentifier];
	if (theTileLayer == NULL)
		{
		CGImageRef theImage = NULL;
		theImage = [UIImage imageNamed:@"TilePlaceholder.png"].CGImage;

		theTileLayer = [self.layerPool createObject];
		theTileLayer.anchorPoint = CGPointMake(1.0, 0.0);
		theTileLayer.coordinate = theTileIdentifier.location;
		theTileLayer.contents = (id)theImage;
		theTileLayer.zPosition = -1;
		CGRect theImageRect = { .origin = CGPointZero, .size = { .width = theTileSize, .height = theTileSize } };
		theTileLayer.frame = theImageRect;
		theTileLayer.position = [self pointForCoordinate:theTileLayer.coordinate];

		[theTileLayer setValue:theTileIdentifier forKey:@"tileIdentifier"];
		
		[theNewTiles addObject:theTileLayer];
		}
	}

// #############################################################################

[CATransaction begin];
[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];

// #############################################################################

// Add all new tiles.
for (CMapObjectLayer *theTileLayer in theNewTiles)
	{
	CTileIdentifier *theTileIdentifier = [theTileLayer valueForKey:@"tileIdentifier"];

	[self addSublayer:theTileLayer];
	[self.tileLayers setObject:theTileLayer forKey:theTileIdentifier];
	[self.mapObjectLayers addObject:theTileLayer];
	
	UIImage *theImage = [self.map.tileManager tileImageForTileIdentifier:theTileIdentifier];
	if (theImage)
		{
		theTileLayer.contents = (id)theImage.CGImage;
		}
	}

[CATransaction commit];

NSLog(@"Count: %d", self.tileLayers.count);
}

- (void)repositionLayers
{
for (CMapObjectLayer *theLayer in self.mapObjectLayers)
	{
	CGPoint thePoint =  [self pointForCoordinate:theLayer.coordinate];
	thePoint = [self.markerContainerLayer convertPoint:thePoint fromLayer:self];
	theLayer.position = thePoint;
	}
}

#pragma mark -

- (CGPoint)pointForCoordinate:(CLLocationCoordinate2D)inCoordinate
{
const CIntegerPoint thePixelXY = [self.map coordinateToPixelXY:inCoordinate levelOfDetail:self.map.levelOfDetail];
const CGPoint theTileOrigin = self.map.tileOrigin;

CGPoint thePoint = {
	.x = thePixelXY.x - theTileOrigin.x,
	.y = thePixelXY.y - theTileOrigin.y,
	};

const CGFloat theMapSizePixels = self.map.mapSizePixels;
thePoint.x = fmod(thePoint.x + theMapSizePixels, theMapSizePixels);

return(thePoint);
}

- (CLLocationCoordinate2D)coordinateForPoint:(CGPoint)inPoint
{
const CGPoint theTileOrigin = self.map.tileOrigin;

CGPoint thePoint = {
	.x = inPoint.x + theTileOrigin.x,
	.y = inPoint.y + theTileOrigin.y,
	};

const int theMapSizePixels = self.map.mapSizePixels;
CIntegerPoint thePixelXY = {
	.x = (int)(round(thePoint.x) + theMapSizePixels) % theMapSizePixels,
	.y = (int)(round(thePoint.y) + theMapSizePixels) % theMapSizePixels,
	};
CLLocationCoordinate2D theCoordinate = [self.map pixelXYToCoordinate:thePixelXY levelOfDetail:self.map.levelOfDetail];
return(theCoordinate);
}

- (CLLocationCoordinate2D)centerCoordinate
{
const CGRect theBounds = self.bounds;
const CGFloat theMidX = CGRectGetMidX(theBounds), theMidY = CGRectGetMidY(theBounds);
const CGPoint theCenter = { .x = theMidX, .y = theMidY };

CLLocationCoordinate2D theCenterCoordinate = [self coordinateForPoint:theCenter];
return(theCenterCoordinate);
}

#pragma mark -

- (void)addMarker:(CMarkerLayer *)inMarker
{
[self.mapObjectLayers addObject:inMarker];
[self.markerContainerLayer addSublayer:inMarker];
[self repositionLayers];
}

- (void)removeMarker:(CMarkerLayer *)inMarker
{
[self.mapObjectLayers removeObject:inMarker];
[inMarker removeFromSuperlayer];
}

#pragma mark -

- (void)scrollBy:(CGPoint)inDelta
{
if (inDelta.x != 0.0 || inDelta.y != 0.0)
	{
	CGPoint thePoint = self.map.tileOrigin;
	thePoint.x += inDelta.x;
	thePoint.y += inDelta.y;
	[self scrollToPoint:thePoint];
	}
}

- (void)scrollToPoint:(CGPoint)inPoint
{
// Clamp the new origin.
const CGFloat theMapSizePixels = self.map.mapSizePixels;
const CGFloat theMinY = 0.0 - CGRectGetHeight(self.bounds) * 0.5;
const CGFloat theMaxY = 0.0 - CGRectGetHeight(self.bounds) * 0.5 + theMapSizePixels;
inPoint.x = fmod(inPoint.x + theMapSizePixels, theMapSizePixels);		
inPoint.y = MIN(MAX(inPoint.y, theMinY), theMaxY);
self.map.tileOrigin = inPoint;
}

- (void)scrollToCenterPoint:(CGPoint)inPoint
{
const CGRect theBounds = self.bounds;
const CGFloat theMidX = CGRectGetMidX(theBounds), theMidY = CGRectGetMidY(theBounds);

inPoint.x -= theMidX;
inPoint.y -= theMidY;

[self scrollToPoint:inPoint];
}

- (void)scrollToCenterCoordinate:(CLLocationCoordinate2D)inCoordinate
{
const CIntegerPoint thePixelXY = [self.map coordinateToPixelXY:inCoordinate levelOfDetail:self.map.levelOfDetail];
const CGPoint thePoint = {
	.x = thePixelXY.x,
	.y = thePixelXY.y,
	};

[self scrollToCenterPoint:thePoint];
}

#pragma mark -

- (void)tileManagerDidReceiveData:(NSNotification *)inNotification
{
NSDictionary *theUserInfo = inNotification.userInfo;
CTileIdentifier *theTileIdentifier = [theUserInfo objectForKey:@"tileIdentifier"];
CMapObjectLayer *theTileLayer = [self.tileLayers objectForKey:theTileIdentifier];
if (theTileLayer)
	{
	UIImage *theImage = [self.map.tileManager tileImageForTileIdentifier:theTileIdentifier];
	if (theImage)
		theTileLayer.contents = (id)theImage.CGImage;
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChange context:(void *)ioContext
{
if (ioContext == kMapLevelOfDetailModifiedContext || ioContext == kMapTileTypeModifiedContext)
	{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];

	for (CMapObjectLayer *theTileLayer in self.tileLayers.allValues)
		{
		[theTileLayer removeFromSuperlayer];
		[self.mapObjectLayers removeObject:theTileLayer];
		[self.tileLayers removeObjectForKey:[theTileLayer valueForKey:@"tileIdentifier"]];
		}
	self.tileLayers = [NSMutableDictionary dictionary];
	
	[self updateTileLayers];

	[self repositionLayers];

	[CATransaction commit];
	}
else if (ioContext == kMapTileOriginModifiedContext)
	{
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
	//
	[self updateTileLayers];
	[self repositionLayers];
	//
	[CATransaction commit];
	}
else
	{
	[super observeValueForKeyPath:inKeyPath ofObject:inObject change:inChange context:ioContext];
	}
}

@end
