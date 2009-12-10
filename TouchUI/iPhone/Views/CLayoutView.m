//
//  CLayoutView.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/12/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CLayoutView.h"

#import "Geometry.h"

@implementation CLayoutView

@synthesize mode;
@synthesize gap;
@synthesize flexibleLastView;
@synthesize fitViews;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	mode = LayoutMode_VerticalStack;
	gap = CGSizeMake(5, 5);
	flexibleLastView = YES;
	fitViews = YES;

	self.autoresizesSubviews = NO;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;

	#if DEBUG_RECT == 1
	self.contentMode = UIViewContentModeRedraw;
	#endif /* DEBUG_RECT == 1 */
	}
return(self);
}

- (id)initWithCoder:(NSCoder *)inDecoder
{
if ((self = [super initWithCoder:inDecoder]) != NULL)
	{
	mode = LayoutMode_VerticalStack;
	gap = CGSizeMake(5, 5);
	flexibleLastView = YES;
	fitViews = YES;

	self.autoresizesSubviews = NO;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
//	self.clipsToBounds = YES;

	#if DEBUG_RECT == 1
	self.contentMode = UIViewContentModeRedraw;
	#endif /* DEBUG_RECT == 1 */
	}
return(self);
}

- (void)setFrame:(CGRect)inFrame
{
[super setFrame:inFrame];
}

#if DEBUG_RECT == 1
- (void)drawRect:(CGRect)rect
{
[[UIColor yellowColor] set];
for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;
	CGContextStrokeRect(UIGraphicsGetCurrentContext(), theFrame);
	}
}
#endif /* DEBUG_RECT == 1 */

- (CGSize)sizeThatFits:(CGSize)size
{
CGRect theUnionFrame = CGRectZero;

CGFloat N = 0.0f;
for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;

	if (mode == LayoutMode_VerticalStack)
		{
		theFrame.origin.y = N;
		N += theView.frame.size.height + self.gap.height;
		}
	else if (mode == LayoutMode_HorizontalStack)
		{
		theFrame.origin.x = N;
		N += theView.frame.size.width + self.gap.width;
		}

	theUnionFrame = CGRectUnion(theUnionFrame, theFrame);
	}

size = CGSizeMake(MIN(size.width, theUnionFrame.size.width), MIN(size.height, theUnionFrame.size.height));

return(size);
}

- (void)layoutSubviews
{
const CGFloat theMax = mode == LayoutMode_VerticalStack ? self.bounds.size.height : self.bounds.size.width;

CGFloat N = 0.0f;

for (UIView *theView in self.subviews)
	{
	CGRect theFrame = theView.frame;

	if (mode == LayoutMode_VerticalStack)
		{
		theFrame.origin.y = N;

		if (self.fitViews)
			{
			theFrame.origin.x = 0;
			theFrame.size.width = self.bounds.size.width;
			}

		if (N < theMax && theFrame.origin.y + theFrame.size.height > theMax)
			{
			theFrame.size.height = theMax - theFrame.origin.y;
			}
		N += theView.frame.size.height + self.gap.height;
		}
	else if (mode == LayoutMode_HorizontalStack)
		{
		theFrame.origin.x = N;

		if (self.flexibleLastView && theView == [self.subviews lastObject])
			{
			if (N < theMax && theFrame.origin.x + theFrame.size.width >= theMax)
				{
				theFrame.size.width = theMax - theFrame.origin.x;
				}
			else
				{
				theFrame.size.width = theMax - theFrame.origin.x;
				}
			}
		N += theView.frame.size.width + self.gap.width;
		}

	theView.frame = theFrame;
	}
}

- (void)addSubview:(UIView *)inSubview
{
[super addSubview:inSubview];
}

@end
