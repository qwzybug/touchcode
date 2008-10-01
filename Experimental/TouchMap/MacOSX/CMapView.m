//
//  CMapView.m
//  MapToy_OSX
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CMapView.h"

#import "CMapLayer.h"
#import "CMap.h"

@implementation CMapView

- (void)awakeFromNib
{
CMap *theMap = [[[CMap alloc] init] autorelease];
theMap.tileOrigin = CGPointZero;


CMapLayer *theMapLayer = [CMapLayer layer];
theMapLayer.map = theMap;
theMapLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
theMapLayer.frame = NSRectToCGRect(self.bounds);

theMapLayer.borderWidth = 1.0;

[self.layer addSublayer:theMapLayer];

}

@end
