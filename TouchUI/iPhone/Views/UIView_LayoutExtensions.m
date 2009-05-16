//
//  UIView_LayoutExtensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "UIView_LayoutExtensions.h"

@implementation UIView (UIView_LayoutExtensions)

- (void)layoutSubviewsUsingMethod:(ELayoutMethod)inMethod
{
switch (inMethod)
	{
	case LayoutMethod_MakeColumn:
		{
		CGFloat theMaxY = 0;
		
		for (UIView *theSubview in self.subviews)
			{
			if (theSubview.hidden == YES)
				{
				continue;
				}
			CGRect theFrame = theSubview.frame;
			theFrame.origin.y = theMaxY;
			theSubview.frame = theFrame;
			
			theMaxY = CGRectGetMaxY(theSubview.frame);
			}
		}
		break;
	default:
		break;
	}
}

- (void)adjustFrameToFramesOfSubviews
{
CGRect theRect = CGRectZero;

for (UIView *theView in self.subviews)
	{
	if (theView.hidden == YES)
		{
		continue;
		}
	theRect = CGRectUnion(theRect, theView.frame);
	}

self.frame = theRect;
}

- (void)dumpViewTree
{
[self dumpViewTree:0 maxDepth:2];
}

- (void)dumpViewTree:(int)inCurrentDepth maxDepth:(int)inMaxDepth;
{
if (inCurrentDepth >= inMaxDepth)
	return;
char theSpaces[] = "                                                                                                                                ";
theSpaces[inCurrentDepth] = '\0';
for (UIView *theView in self.subviews)
	{
	[theView dumpViewTree:inCurrentDepth + 1 maxDepth:inMaxDepth];
	}
}

@end
