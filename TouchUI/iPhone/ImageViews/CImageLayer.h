//
//  CImageLayer.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CImageProvider;

@interface CImageLayer : CALayer {
	CImageProvider *imageProvider;
}

@property (readwrite, nonatomic, retain) CImageProvider *imageProvider;

@end
