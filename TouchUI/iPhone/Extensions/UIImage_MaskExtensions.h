//
//  UIImage_MaskExtensions.h
//  PlateView
//
//  Created by Jonathan Wight on 1/16/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_MaskExtensions)

- (UIImage *)sizedImage:(CGSize)inSize;
- (CGImageRef)mask;

@end
