//
//  QuartzUtilities.m
//  MapToy
//
//  Created by Jonathan Wight on 04/29/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "QuartzUtilities.h"

#if TARGET_OS_MAC
#elif TARGET_OS_IPHONE
#include <UIKit/UIKit.h>
#endif

CGImageRef CGImageCreateImageNamed(CFStringRef inName)
{
CGImageRef theImage = NULL;
#if TARGET_OS_IPHONE == 0
	NSBundle *theBundle = [NSBundle mainBundle];
	NSString *thePath = [theBundle pathForResource:[(NSString *)inName stringByDeletingPathExtension] ofType:[(NSString *)inName pathExtension]];
	NSURL *theURL = [NSURL fileURLWithPath:thePath];
	CGImageSourceRef theImageSource = CGImageSourceCreateWithURL((CFURLRef)theURL, NULL);
	theImage = CGImageSourceCreateImageAtIndex(theImageSource, 0, NULL);
	CFRelease(theImageSource);
#else
	UIImage *theUIKitImage = [UIImage imageNamed:(NSString *)inName];
	theImage = [theUIKitImage CGImage];
#endif
return(theImage);
}

