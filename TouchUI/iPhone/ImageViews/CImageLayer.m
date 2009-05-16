//
//  CImageLayer.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CImageLayer.h"

#import "CImageProvider.h"

static NSString *const kImageProviderImageChanged = @"kImageProviderImageChanged";

@implementation CImageLayer

@synthesize imageProvider;

- (void)dealloc
{
self.imageProvider = NULL;
//
[super dealloc];
}

#pragma mark -

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
		[imageProvider removeObserver:self forKeyPath:@"image"];
		[imageProvider autorelease];
		}
		
	if (inImageProvider != NULL)
		{
		imageProvider = [inImageProvider retain];
		[imageProvider addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionInitial context:kImageProviderImageChanged];
		}
    }
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
if (context == kImageProviderImageChanged)
	{
	self.contents = (id)self.imageProvider.image.CGImage;
	}
else
	{
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
