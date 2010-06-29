//
//  CBadgeView.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import "CBadgeView.h"

#import "QuartzUtilities.h"
#import "CLayoutView.h"
#import "UIView_LayoutExtensions.h"

@interface CBadgeView ()
@property (readwrite, nonatomic, retain) CLayoutView *layoutView;
@end

#pragma mark -

@implementation CBadgeView

@synthesize imageView;
@synthesize accessoryView;
@synthesize badgePosition;

- (id)initWithFrame:(CGRect)frame
{
if (CGRectIsEmpty(frame))
	frame = CGRectMake(0, 0, 320, 44);

if ((self = [super initWithFrame:frame]) != NULL)
	{
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.contentMode = UIViewContentModeRedraw;
	self.autoresizesSubviews = NO;
	self.badgePosition = BadgePositionBottomRight;
	}
return(self);
}

- (void)dealloc
{
[imageView release];
imageView = NULL;
//
[titleLabel release];
titleLabel = NULL;
//
[accessoryView release];
accessoryView = NULL;
//
[layoutView release];
layoutView = NULL;
//
[super dealloc];
}

#pragma mark -

- (UIView *)accessoryView
{
if (accessoryView == NULL)
	{
	UIActivityIndicatorView *theActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 2, 20, 20)];
	[theActivityIndicator startAnimating];
	accessoryView = theActivityIndicator;
	}
return(accessoryView);
}

- (UIImageView *)imageView
{
if (imageView == NULL)
	{
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	}
return(imageView);
}

- (UILabel *)titleLabel
{
if (titleLabel == NULL)
	{
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.layoutView.bounds.size.width, 23)];
	titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	titleLabel.textAlignment = UITextAlignmentLeft;
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.shadowColor = [UIColor blackColor];
	titleLabel.shadowOffset = CGSizeMake(2, 2);
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.opaque = NO;
//	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

	titleLabel.userInteractionEnabled = NO;
	}
return(titleLabel);
}

- (CLayoutView *)layoutView
{
if (layoutView == NULL)
	{
	CGRect theFrame = self.bounds;

	layoutView = [[CLayoutView alloc] initWithFrame:theFrame];
	layoutView.mode = LayoutMode_HorizontalStack;
	layoutView.gap = CGSizeMake(5, 5);
	layoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	layoutView.userInteractionEnabled = NO;
	}
return(layoutView);
}

- (CGSize)sizeThatFits:(CGSize)size
{
CGSize theLayoutViewSize = CGSizeMake(size.width - 10, size.height - 10);

CGSize theSize = [self.layoutView sizeThatFits:theLayoutViewSize];
theSize.width += 10;
theSize.height += 10;
theSize.width = MIN(size.width, theSize.width);
theSize.height = MIN(size.height, theSize.height);

return(theSize);
}

//- (void)sizeToFit
//{
//[self layoutSubviews];
//
//[super sizeToFit];
//}

- (void)layoutSubviews
{
if (layoutView != NULL)
	[self addSubview:self.layoutView];

if (imageView != NULL)
	{
	if (self.imageView.image != NULL)
		{
		[self.layoutView addSubview:self.imageView];
		}
	else
		{
		[self.imageView removeFromSuperview];
		}
	}
if (titleLabel != NULL)
	{
	if (self.titleLabel.text.length > 0)
		{
		self.titleLabel.frame = CGRectMake(0, 0, self.layoutView.bounds.size.width - 10.0f, 23);
		[self.titleLabel sizeToFit:CGSizeMake(INFINITY, INFINITY)];
		[self.layoutView addSubview:self.titleLabel];
		self.layoutView.flexibleView = titleLabel;
		}
	else
		{
		[self.titleLabel removeFromSuperview];
		}
	}

if (self.accessoryView)
	{
	[self.layoutView addSubview:self.accessoryView];
	}

self.layoutView.frame = CGRectInset(self.bounds, 10, 2);
}

- (void)drawRect:(CGRect)inRect
{
CGRect theRect = self.bounds;

CGContextRef theContext = UIGraphicsGetCurrentContext();

[[UIColor colorWithWhite:0.0f alpha:0.6f] set];

switch (badgePosition)
	{
	case BadgePositionTopLeft:
		CGContextAddRoundRectToPath(theContext, theRect, 0, 0, 0, 20);
		break;
	case BadgePositionTopRight:
		CGContextAddRoundRectToPath(theContext, theRect, 0, 0, 20, 0);
		break;
	case BadgePositionBottomLeft:
		CGContextAddRoundRectToPath(theContext, theRect, 0, 20, 0, 0);
		break;
	case BadgePositionBottomRight:
		CGContextAddRoundRectToPath(theContext, theRect, 20, 0, 0, 0);
		break;
	default:
		break;
	}

CGContextFillPath(theContext);

#if DEBUG_RECT == 1
[[UIColor redColor] set];
CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.bounds);
[[UIColor orangeColor] set];
for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), theFrame);
	}
#endif /* DEBUG_RECT == 1 */
}

@end
