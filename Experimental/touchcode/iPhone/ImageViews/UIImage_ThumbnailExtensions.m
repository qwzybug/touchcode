//
//  UIImage_ThumbnailExtensions.m
//  TouchCode
//
//  Created by Ian Baird on 3/28/08.
//  Copyright 2008 Skorpiostech, Inc.. All rights reserved.
//

#import "UIImage_ThumbnailExtensions.h"


@implementation UIImage (UIImage_ThumbnailExtensions)

- (UIImage *)thumbnail:(CGSize)thumbSize cropped:(BOOL)cropped
{
    CGRect destRect = CGRectMake(0.0, 0.0, thumbSize.width, thumbSize.height);
    
	CGImageRef srcImage;
	
	if (!cropped) {
		if (self.size.width > self.size.height)
		{
			// Scale height down
			destRect.size.height = ceilf(self.size.height * (thumbSize.width / self.size.width));
			
			// Recenter
			destRect.origin.y = (thumbSize.height - destRect.size.height) / 2.0;
		}
		else if (self.size.width < self.size.height)
		{
			// Scale width down
			destRect.size.width = ceilf(self.size.width * (thumbSize.height / self.size.height));
			
			// Recenter
			destRect.origin.x = (thumbSize.width - destRect.size.width) / 2.0;
		}
		
		srcImage = self.CGImage;
	} else {
		// crop source image to a square
		float croppedSize = MIN(self.size.width, self.size.height);
		
		CGRect srcRect = CGRectMake((self.size.width - croppedSize) / 2,
									(self.size.height - croppedSize) / 2,
									croppedSize, croppedSize);
		
		srcImage = CGImageCreateWithImageInRect(self.CGImage, srcRect);
	}
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL, thumbSize.width, thumbSize.height, 8, (4 * thumbSize.width), genericColorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationHigh);
    CGContextDrawImage(thumbBitmapCtxt, destRect, srcImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    
    CGImageRelease(tmpThumbImage);
	
	if (cropped)
		CGImageRelease(srcImage);
    
    return result;
}

- (UIImage *)thumbnail:(CGSize)thumbSize
{
	return [self thumbnail:thumbSize cropped:NO];
}

@end
