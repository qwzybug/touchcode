//
//  CMapView.m
//  Nearby
//
//  Created by Jonathan Wight on 04/24/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CMapView.h"

#import <CoreLocation/CoreLocation.h>

#import "CURLConnectionManagerChannel.h"
#import "CMapLayer.h"
#import "CMap.h"
#import "CTileManager.h"

@implementation CMapView

@dynamic map;
@synthesize placeholderImage;
@dynamic mainlayer;
@synthesize eventHandler;

+ (Class)layerClass
{
return([CMapLayer class]);
}

- (void)dealloc
{
self.map = NULL;
self.placeholderImage = NULL;
self.eventHandler = NULL;
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
		[map release];
		map = NULL;
		self.mainlayer.map = NULL;
		}
		
	if (inMap)
		{
		map = [inMap retain];
		self.mainlayer.map = map;
		}
    }
}

- (CMapLayer *)mainlayer
{
return((CMapLayer *)self.layer);
}

- (UIImage *)placeholderImage
{
if (placeholderImage == NULL)
	placeholderImage = [[UIImage imageNamed:@"TilePlaceholder.png"] retain];
return(placeholderImage);
}

#pragma mark -

- (void)awakeFromNib
{
self.multipleTouchEnabled = YES;
self.backgroundColor = [UIColor groupTableViewBackgroundColor];

self.layer.frame = self.bounds;
}

- (UIResponder *)nextResponder
{
if (self.eventHandler == NULL)
	{
	self.eventHandler = [[[CEventHandler alloc] init] autorelease];
	self.eventHandler.delegate = self;
	self.eventHandler.view = self;
	}
return(self.eventHandler);
}

#pragma mark -

- (BOOL)eventHandlerShouldScroll:(CEventHandler *)inEventHandler;
{
return(YES);
}

- (void)eventHandlerDidReceiveDragBegan:(CEventHandler *)inEventHandler
{
dragging = YES;
}

- (void)eventHandlerDidReceiveDragEnded:(CEventHandler *)inEventHandler
{
dragging = NO;
}

- (void)eventHandlerDidReceiveDoubleTap:(CEventHandler *)inEventHandler
{
UITouch *theTouch = inEventHandler.currentTouches.anyObject;
CGPoint theTouchLocation = [theTouch locationInView:self];

CLLocationCoordinate2D theCoordinate = [self.mainlayer coordinateForPoint:theTouchLocation];

[CATransaction begin];
[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];

self.map.levelOfDetail += 1;
[self.mainlayer scrollToCenterCoordinate:theCoordinate];

[CATransaction commit];
}

- (void)eventHandler:(CEventHandler *)inEventHandler didReceiveZoomBy:(CGFloat)inDelta center:(CGPoint)inCenter
{
CLLocationCoordinate2D theCenterCoordinate = [self.mainlayer centerCoordinate];

[CATransaction begin];
[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];

self.map.levelOfDetailFloat += (inDelta / 400.0);
[self.mainlayer scrollToCenterCoordinate:theCenterCoordinate];

[CATransaction commit];
}

- (void)eventHandler:(CEventHandler *)inEventHandler didReceiveScrollBy:(CGPoint)inDelta
{
[self.mainlayer scrollBy:inDelta];
}

@end