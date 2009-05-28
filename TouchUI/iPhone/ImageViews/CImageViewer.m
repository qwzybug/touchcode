//
//  CImageViewer.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/28/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CImageViewer.h"

#import "CImageProvider.h"
#import "Geometry.h"

static NSString *const kImageProviderImageChanged = @"kImageProviderImageChanged";

@interface CImageViewer ()

@property (readwrite, nonatomic, retain) UIImageView *contentView;

@end

#pragma mark -

@implementation CImageViewer

@dynamic image;
@dynamic imageProvider;
@synthesize zoomed;
@synthesize contentView;

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != NULL)
	{
	self.delegate = self;
	
	self.contentView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
	self.zoomed = NO;

	[self addSubview:self.contentView];
	
	}
return(self);
}

- (void)dealloc
{
self.image = NULL;
self.imageProvider = NULL;
self.contentView = NULL;
//	
[super dealloc];
}

#pragma mark -

- (void)layoutSubviews
{
CGRect theViewBounds = self.bounds;

CGRect theImageRect = { .origin = CGPointZero, .size = self.image.size };
if (self.zoomed == NO)
	{
	theViewBounds.origin = CGPointZero;
	theImageRect = ScaleAndAlignRectToRect(theImageRect, theViewBounds, ImageScaling_Proportionally, ImageAlignment_Center);

	self.contentView.frame = theImageRect;
	self.contentSize = theImageRect.size;
	}
else
	{
	self.contentView.frame = theImageRect;
	self.contentSize = theImageRect.size;
	}
}

#pragma mark -

- (UIImage *)image
{
return(image); 
}

- (void)setImage:(UIImage *)inImage
{
if (image != inImage)
	{
	if (image != NULL)
		{
		[image release];
		image = NULL;

		self.contentView.image = NULL;
		}
	
	if (inImage != NULL)
		{
		image = [inImage retain];
		
		self.contentView.image = image;
		}

	[self layoutSubviews];
    }
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
		[imageProvider removeObserver:self forKeyPath:@"image"];
		
		[imageProvider release];
		imageProvider = NULL;
		}
		
	if (inImageProvider != NULL)
		{
		imageProvider = [inImageProvider retain];

		[imageProvider addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionInitial context:kImageProviderImageChanged];
		}
    }
}

- (BOOL)zoomed
{
return zoomed;
}

- (void)setZoomed:(BOOL)flag
{
if (zoomed != flag)
	{
	zoomed = flag;

	[self layoutSubviews];
	}
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
if (touches.count == 1)
	{
	UITouch *theTouch = [touches anyObject];
	if (theTouch.tapCount == 2)
		{
		self.zoomed = !self.zoomed;
		return;
		}
	}

[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
[super touchesCancelled:touches withEvent:event];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
if (context == kImageProviderImageChanged)
	{
	self.image = self.imageProvider.image;
	}
else
	{
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
return(self.contentView);
}

@end
