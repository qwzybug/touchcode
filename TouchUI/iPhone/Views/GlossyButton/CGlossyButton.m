//
//  CGlossyButton.m
//  Birdfeed Redux
//
//  Created by Jonathan Wight on 03/30/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CGlossyButton.h"


@implementation CGlossyButton

+ (CGlossyButton *)buttonWithTitle:(NSString *)inTitle target:(id)inTarget action:(SEL)inAction
{
CGlossyButton *theButton = [self buttonWithType:UIButtonTypeCustom];
[theButton setTitle:inTitle forState:UIControlStateNormal];
theButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
theButton.titleLabel.textColor = [UIColor darkTextColor];
theButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;

NSString *theImagePrefix = @"glossyButton";

UIImage *theImage = NULL;

theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-normal.png", theImagePrefix]];
if (theImage)
	{
	theImage = [theImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[theButton setBackgroundImage:theImage forState:UIControlStateNormal];
	}

theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-disabled.png", theImagePrefix]];
if (theImage)
	{
	theImage = [theImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[theButton setBackgroundImage:theImage forState:UIControlStateDisabled];
	}

theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-highlighted.png", theImagePrefix]];
if (theImage)
	{
	theImage = [theImage stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[theButton setBackgroundImage:theImage forState:UIControlStateHighlighted];
	}


[theButton addTarget:inTarget action:inAction forControlEvents:UIControlEventTouchUpInside];

return(theButton);
}

@end
