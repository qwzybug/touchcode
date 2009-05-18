//
//  UIImage_MaskExtensions.m
//  PlateView
//
//  Created by Jonathan Wight on 1/16/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "UIImage_MaskExtensions.h"


@implementation UIImage (UIImage_MaskExtensions)

- (UIImage *)sizedImage:(CGSize)inSize
{
CGImageRef theImage = self.CGImage;
CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceGray();
size_t theComponentCount = CGColorSpaceGetNumberOfComponents(theColorSpace);
size_t theBitsPerComponent = 8; // CGImageGetBitsPerComponent(theImage);
size_t theWidth = ceil(inSize.width);
size_t theHeight = ceil(inSize.height);
size_t theBytesPerRow = theWidth * (theBitsPerComponent * theComponentCount) / 8;
size_t theLength = theHeight * theBytesPerRow;
NSMutableData *theData = [NSMutableData dataWithLength:theLength];
CGContextRef theBitmapContext = CGBitmapContextCreate(theData.mutableBytes, theWidth, theHeight, theBitsPerComponent, theBytesPerRow, theColorSpace, kCGImageAlphaNone);

CGRect theBounds = { .origin = CGPointZero, .size = inSize };

UIGraphicsPushContext(theBitmapContext);
[self drawInRect:theBounds];
UIGraphicsPopContext();

theImage = CGBitmapContextCreateImage(theBitmapContext);
CGContextRelease(theBitmapContext);
if (theColorSpace)
CFRelease(theColorSpace);

UIImage *theNewImage = [UIImage imageWithCGImage:theImage];

CFRelease(theImage);

return(theNewImage);
}

- (CGImageRef)mask
{
CGImageRef theImage = self.CGImage;
CGImageRef theMask = CGImageMaskCreate(CGImageGetWidth(theImage), CGImageGetHeight(theImage), CGImageGetBitsPerComponent(theImage), CGImageGetBitsPerPixel(theImage), CGImageGetBytesPerRow(theImage), CGImageGetDataProvider(theImage), NULL, YES);

[(id)theMask autorelease];

return(theMask);
}

@end
