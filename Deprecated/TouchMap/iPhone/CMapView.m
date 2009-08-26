//
//  CMapView.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/24/08.
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

#import "CMapView.h"

#import <CoreLocation/CoreLocation.h>

#import "CURLConnectionManagerChannel.h"
#import "CMapLayer.h"
#import "CMap.h"
#import "CTileManager.h"

@implementation CMapView

@dynamic map;
@synthesize placeholderImage;
@dynamic mapLayer;
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
		self.mapLayer.map = NULL;
		}
		
	if (inMap)
		{
		map = [inMap retain];
		self.mapLayer.map = map;
		}
    }
}

- (CMapLayer *)mapLayer
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
//self.map.tileManager.enableDownloads = NO;
}

- (void)eventHandlerDidReceiveDragEnded:(CEventHandler *)inEventHandler
{
dragging = NO;
//self.map.tileManager.enableDownloads = YES;
}

- (void)eventHandlerDidReceiveDoubleTap:(CEventHandler *)inEventHandler
{
UITouch *theTouch = inEventHandler.currentTouches.anyObject;
CGPoint theTouchLocation = [theTouch locationInView:self];

CLLocationCoordinate2D theCoordinate = [self.mapLayer coordinateForPoint:theTouchLocation];

[CATransaction begin];
[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];

self.map.levelOfDetail += 1;
[self.mapLayer scrollToCenterCoordinate:theCoordinate];

[CATransaction commit];
}

- (void)eventHandler:(CEventHandler *)inEventHandler didReceiveZoomBy:(CGFloat)inDelta center:(CGPoint)inCenter
{
CLLocationCoordinate2D theCenterCoordinate = [self.mapLayer centerCoordinate];

[CATransaction begin];
[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];

self.map.levelOfDetailFloat += (inDelta / 400.0);
[self.mapLayer scrollToCenterCoordinate:theCenterCoordinate];

[CATransaction commit];
}

- (void)eventHandler:(CEventHandler *)inEventHandler didReceiveScrollBy:(CGPoint)inDelta
{
[self.mapLayer scrollBy:inDelta];
}

@end