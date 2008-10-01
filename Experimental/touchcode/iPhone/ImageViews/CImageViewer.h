//
//  CImageViewer.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CImageProvider;

@interface CImageViewer : UIScrollView <UIScrollViewDelegate> {
	UIImage *image;
	CImageProvider *imageProvider;
	BOOL zoomed;
	UIImageView *contentView;
}

@property (readwrite, nonatomic, retain) UIImage *image;
@property (readwrite, nonatomic, retain) CImageProvider *imageProvider;
@property (readwrite, nonatomic, assign) BOOL zoomed;

@end
