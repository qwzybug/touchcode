//
//  CLocationLayer.h
//  Nearby
//
//  Created by Jonathan Wight on 06/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CMapObjectLayer.h"

@class CMap;

@interface CLocationLayer : CMapObjectLayer {
	CMap *map;
	CGFloat accuracyRadius;
	BOOL observing;
}

@property (readwrite, nonatomic, retain) CMap *map;
@property (readwrite, assign) CGFloat accuracyRadius;

@end
