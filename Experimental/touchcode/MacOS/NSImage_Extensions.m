//
//  NSImage_Extensions.m
//  MapToy
//
//  Created by Jonathan Wight on 04/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "NSImage_Extensions.h"


@implementation NSImage (NSImage_Extensions)

- (CGImageRef)CGImage
{
CGSize theImageSize = NSSizeToCGSize([self size]);

if (theImageSize.width <= 0.0 || theImageSize.height <= 0.0) [NSException raise:NSGenericException format:@"Cannot create CGImage from CIImage with zero extents"];

const size_t theRowBytes = theImageSize.width * 4;
const size_t theSize = theRowBytes * theImageSize.height;

NSMutableData *theData = [NSMutableData dataWithLength:theSize];
if (theData == NULL) [NSException raise:NSGenericException format:@"Could not create data."];

CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceRGB();
if (theColorSpace == NULL) [NSException raise:NSGenericException format:@"CGColorSpaceCreateDeviceRGB() failed."];

CGContextRef theBitmapContext = CGBitmapContextCreate([theData mutableBytes], theImageSize.width, theImageSize.height, 8, theRowBytes, theColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
if (theBitmapContext == NULL) [NSException raise:NSGenericException format:@"theBitmapContext() failed."];

[NSGraphicsContext saveGraphicsState];
[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:theBitmapContext flipped:NO]];

NSRect theFrame = { .origin = NSZeroPoint, .size = [self size] };
[self drawInRect:theFrame fromRect:theFrame operation:NSCompositeSourceOver fraction:1.0];
CFRelease(theBitmapContext);

[NSGraphicsContext restoreGraphicsState];


CGDataProviderRef theDataProvider = CGDataProviderCreateWithData(NULL, [theData mutableBytes], [theData length], NULL);
if (theDataProvider == NULL) [NSException raise:NSGenericException format:@"CGDataProviderCreateWithData() failed."];

CGImageRef theCGImage = CGImageCreate(theImageSize.width, theImageSize.height, 8, 32, theRowBytes, theColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst, theDataProvider, NULL, NO, kCGRenderingIntentDefault);
if (theCGImage == NULL) [NSException raise:NSGenericException format:@"CGImageCreate() failed."];

CFRelease(theDataProvider);

CFRelease(theColorSpace);

return(theCGImage);
}


@end
