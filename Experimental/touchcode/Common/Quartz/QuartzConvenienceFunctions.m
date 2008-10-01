//
//  QuartzConvenienceFunctions.m
//  TouchWar_MacOS
//
//  Created by Jonathan Wight on 05/09/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "QuartzConvenienceFunctions.h"

CGImageRef CGImageNamed(CFStringRef inName)
{
CGImageRef theImage = NULL;

#if TARGET_OS_IPHONE
UIImage *theUIImage = [UIImage imageNamed:(NSString *)inName];
theImage = theUIImage.CGImage;
#else
NSBundle *theBundle = [NSBundle mainBundle];
NSString *thePath = [theBundle pathForResource:[(NSString *)inName stringByDeletingPathExtension] ofType:[(NSString *)inName pathExtension]];
NSURL *theFileURL = [NSURL fileURLWithPath:thePath];
CGImageSourceRef theImageSource = CGImageSourceCreateWithURL((CFURLRef)theFileURL, NULL);
theImage = CGImageSourceCreateImageAtIndex(theImageSource, 0, NULL);

CFRelease(theImageSource);
#endif


return(theImage);
}
