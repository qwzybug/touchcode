//
//  CBubbleView.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/12/09.
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

#import "CBubbleView.h"

#import "UIView_LayoutExtensions.h"
#import "Geometry.h"

#import "CLayoutView.h"

@interface CBubbleView ()

@property (readwrite, nonatomic, retain) CLayoutView *layoutView;

@end

#pragma mark -

@implementation CBubbleView

@synthesize accessoryViews;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.opaque = NO;
	self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
	self.autoresizesSubviews = NO;
	#if DEBUG_RECT == 1
	self.contentMode = UIViewContentModeRedraw;
	#endif /* DEBUG_RECT == 1 */
	}
return(self);
}

- (id)init
{
return([self initWithFrame:CGRectMake(0, 0, 320, 44)]);
}

- (void)dealloc
{
[titleLabel release];
titleLabel = NULL;
//
[messageLabel release];
messageLabel = NULL;
//
[accessoryViews release];
accessoryViews = NULL;
//
[layoutView release];
layoutView = NULL;
//
[super dealloc];
}

- (UILabel *)titleLabel
{
if (titleLabel == NULL)
	{
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.layoutView.bounds.size.width, 18)];
	titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.shadowColor = [UIColor blackColor];
	titleLabel.shadowOffset = CGSizeMake(2, 2);
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.opaque = NO;
	}
return(titleLabel);
}

- (UILabel *)messageLabel
{
if (messageLabel == NULL)
	{
	messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.layoutView.bounds.size.width, 18)];
	messageLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] - 2.0f];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.shadowColor = [UIColor blackColor];
	messageLabel.shadowOffset = CGSizeMake(2, 2);

	messageLabel.textAlignment = UITextAlignmentCenter;
	messageLabel.numberOfLines = 1;
	messageLabel.lineBreakMode = UILineBreakModeTailTruncation;

	messageLabel.backgroundColor = [UIColor clearColor];

	messageLabel.opaque = NO;
	}
return(messageLabel);
}

- (CLayoutView *)layoutView
{
if (layoutView == NULL)
	{
	CGRect theFrame = CGRectInset(self.bounds, 10, 10);
	layoutView = [[CLayoutView alloc] initWithFrame:theFrame];
	layoutView.mode = LayoutMode_VerticalStack;
	layoutView.gap = CGSizeMake(5, 5);
	}
return(layoutView);
}

#pragma mark -

#if DEBUG_RECT == 1
- (void)drawRect:(CGRect)rect
{
[[UIColor redColor] set];
CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.bounds);
[[UIColor orangeColor] set];
for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), theFrame);
	}
}
#endif /* DEBUG_RECT == 1 */

- (CGSize)sizeThatFits:(CGSize)size
{
CGSize theSize = { size.width - 20, size.height - 20 };
theSize = [self.layoutView sizeThatFits:theSize];
theSize.width += 20;
theSize.height += 20;
return(theSize);
}

- (void)layoutSubviews
{
if (titleLabel != NULL)
	{
	if (self.titleLabel.text.length > 0)
		{
		self.titleLabel.frame = CGRectMake(0, 0, self.layoutView.bounds.size.width, 18);
		[self.layoutView addSubview:self.titleLabel];
		}
	else
		{
		[self.titleLabel removeFromSuperview];
		}
	}

if (messageLabel != NULL)
	{
	if (self.messageLabel.text.length > 0)
		{
		[self.messageLabel sizeToFit:CGSizeMake(self.layoutView.bounds.size.width, INFINITY)];
		[self.layoutView addSubview:self.messageLabel];
		}
	else
		{
		[self.messageLabel removeFromSuperview];
		}
	}

CGRect theBounds = self.bounds;
for (UIView *theView in self.accessoryViews)
	{
	CGRect theFrame = theView.frame;
	theFrame.origin.x = (CGRectGetWidth(theBounds) - CGRectGetWidth(theFrame)) * 0.5f;
	theView.frame = theFrame;

	[self.layoutView addSubview:theView];
	}

[self.layoutView sizeToFit:self.bounds.size];
self.layoutView.frame = ScaleAndAlignRectToRect(self.layoutView.frame, self.bounds, ImageScaling_None, ImageAlignment_Center);


if (self.layoutView.superview == NULL)
	{
	[self addSubview:self.layoutView];
	}
}

@end
