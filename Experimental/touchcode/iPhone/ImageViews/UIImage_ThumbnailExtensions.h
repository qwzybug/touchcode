//
//  UIImage_ThumbnailExtensions.h
//  TouchCode
//
//  Created by Ian Baird on 3/28/08.
//  Copyright 2008 Skorpiostech, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (UIImage_ThumbnailExtensions) 

- (UIImage *)thumbnail:(CGSize)thumbSize cropped:(BOOL)cropped;
- (UIImage *)thumbnail:(CGSize)thumbSize;

@end
