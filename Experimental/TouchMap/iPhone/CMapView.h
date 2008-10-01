//
//  CMapView.h
//  Nearby
//
//  Created by Jonathan Wight on 04/24/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CEventHandler.h"

@class CMap;
@class CMapLayer;

@interface CMapView : UIView <CEventHandlerDelegate> {
	CMap *map;
	UIImage *placeholderImage;
	CEventHandler *eventHandler;
	BOOL dragging;
}

@property (readwrite, nonatomic, retain) CMap *map;
@property (readwrite, nonatomic, retain) UIImage *placeholderImage;
@property (readonly, nonatomic, retain) CMapLayer *mainlayer;
@property (readwrite, nonatomic, retain) CEventHandler *eventHandler;

@end
