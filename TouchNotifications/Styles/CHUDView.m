//
//  CHUDView.m
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

#import "CHUDView.h"

#import "QuartzUtilities.h"

@implementation CHUDView

@synthesize borderWidth;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.contentMode = UIViewContentModeRedraw;
	//
	borderWidth = 10.0f;
	}
return(self);
}

- (UIView *)contentView
{
NSAssert(self.subviews.count <= 1, @"TODO");
return([self.subviews lastObject]);
}

- (void)setContentView:(UIView *)inContentView
{
NSAssert(self.subviews.count <= 1, @"TODO");
if (self.subviews.count == 1)
	{
	UIView *theCurrentView = [self.subviews lastObject];
	[theCurrentView removeFromSuperview];
	}

if (inContentView)
	{
	CGRect theFrame = self.bounds;
	theFrame = CGRectInset(theFrame, self.borderWidth, self.borderWidth);
	inContentView.frame = theFrame;
	[self addSubview:inContentView];
	}
}

- (void)drawRect:(CGRect)inRect
{
CGRect theRect = self.bounds;

CGContextRef theContext = UIGraphicsGetCurrentContext();

[[UIColor colorWithWhite:0.0f alpha:0.75f] set];

CGContextAddRoundRectToPath(theContext, theRect, self.borderWidth, self.borderWidth, self.borderWidth, self.borderWidth);
CGContextFillPath(theContext);
}

@end
