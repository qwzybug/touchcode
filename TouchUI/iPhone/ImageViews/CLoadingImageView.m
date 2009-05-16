//
//  CLoadingImageView.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/19/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CLoadingImageView.h"

@implementation CLoadingImageView

@synthesize imageProvider;

- (void)dealloc
{
self.imageProvider = NULL;
//
[super dealloc];
}

- (CImageProvider *)imageProvider
{
return(imageProvider);
}

- (void)setImageProvider:(CImageProvider *)inImageProvider
{
if (imageProvider != inImageProvider)
	{
	if (imageProvider != NULL)
		{
		imageProvider.delegate = NULL;
		//
		[imageProvider autorelease];
		imageProvider = NULL;
		}
	if (inImageProvider != NULL)
		{
		imageProvider = [inImageProvider retain];
		imageProvider.delegate = self;
		}
    }
}

#pragma mark -

- (void)imageProvider:(CImageProvider *)inImageProvider didUpdateImage:(UIImage *)inImage
{
self.image = inImage;
[self setNeedsDisplay];
}

@end
