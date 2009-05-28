//
//  CMapToyViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/01/08.
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

[self.mapView.mapLayer scrollToCenterCoordinate:theCoordinate];
}

@end
