//
//  MapToyAppDelegate.m
//  MapToy
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "CMapToyViewController.h"

#import "CMap.h"
#import "CMapView.h"
#import "CMapLayer.h"

@implementation CMapToyViewController

@synthesize map;
@synthesize mapView = outletMapView;

- (void) dealloc
{
self.map = NULL;
self.mapView = NULL;
//
[super dealloc];
}

//

- (void)loadView
{
[super loadView];

self.map = [[[CMap alloc] init] autorelease];
self.mapView.map = self.map;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(NO);
}

- (IBAction)actionMapStyle1:(id)inSender
{
self.map.tileType = 1;
}

- (IBAction)actionMapStyle2:(id)inSender
{
self.map.tileType = 2;
}

- (IBAction)actionMapStyle3:(id)inSender
{
self.map.tileType = 3;
}

- (IBAction)actionMapStyle4:(id)inSender
{
self.map.tileType = 4;
}

- (IBAction)actionLocate:(id)inSender;
{
CLLocationCoordinate2D theCoordinate = { .latitude = 51.508, .longitude = -0.126 };

[self.mapView.mainlayer scrollToCenterCoordinate:theCoordinate];
}

@end
