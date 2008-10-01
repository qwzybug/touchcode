//
//  CMapObjectLayer.h
//  Nearby
//
//  Created by Jonathan Wight on 06/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CLocation.h"

@interface CMapObjectLayer : CALayer {
	CLLocationCoordinate2D coordinate;
	BOOL draggable;
}

@property (readwrite, assign) CLLocationCoordinate2D coordinate;
@property (readwrite, assign) BOOL draggable;

@end
