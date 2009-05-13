//
//  CBorderView.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBorderView : UIView {
	CGFloat frameInset;
	CGFloat cornerRadius;
	CGFloat frameWidth;
	UIColor *frameColor;
	UIColor *fillColor;
	UIImage *cachedImage;
}

@property (readwrite, nonatomic, assign) CGFloat frameInset;
@property (readwrite, nonatomic, assign) CGFloat cornerRadius;
@property (readwrite, nonatomic, assign) CGFloat frameWidth;
@property (readwrite, nonatomic, retain) UIColor *frameColor;
@property (readwrite, nonatomic, retain) UIColor *fillColor;

- (void)setup;

@end
