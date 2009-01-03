//
//  CLabelledValueTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CLabelledContentTableViewCell.h"

#import "Geometry.h"

@implementation CLabelledContentTableViewCell

@synthesize label;
@dynamic content;

- (id)initWithFrame:(CGRect)frame
{
if (self = [super initWithFrame:frame])
	{
	self.opaque = NO;			
	self.backgroundColor = [UIColor clearColor];

	CGRect theLabelBounds = self.bounds;
	theLabelBounds = CGRectInset(theLabelBounds, 18, 0);

	UILabel *theLabel = [[[UILabel alloc] initWithFrame:theLabelBounds] autorelease];
	theLabel.opaque = NO;			
	theLabel.backgroundColor = [UIColor clearColor];
	theLabel.font = [UIFont boldSystemFontOfSize:theLabel.font.pointSize];
	theLabel.adjustsFontSizeToFitWidth = YES;

	self.label = theLabel;

	[self addSubview:self.label];
	}
return(self);
}

- (void)dealloc
{
self.label = NULL;
self.content = NULL;

[super dealloc];
}

#pragma mark -

- (UIView *)content
{
return(content); 
}

- (void)setContent:(UIView *)inContent
{
if (content != inContent)
	{
	if (content)
		{
		[content removeFromSuperview];
		
		[content autorelease];
		content = NULL;
		}
		
	if (inContent)
		{
		content = [inContent retain];
		[self addSubview:inContent];
		
		[self adjustLayout];
		}
    }
}

#pragma mark -

- (void)adjustLayout
{
const CGRect theSelfBounds = CGRectInset(self.bounds, 18, 6);

if (self.label)
	{
	CGRect theLabelFrame = self.label.frame;
	theLabelFrame = ScaleAndAlignRectToRect(theLabelFrame, theSelfBounds, ImageScaling_None, ImageAlignment_Left);
	self.label.frame = theLabelFrame;
	}
//
if (self.content)
	{
	CGRect theContentFrame = self.content.frame;
	theContentFrame = ScaleAndAlignRectToRect(theContentFrame, theSelfBounds, ImageScaling_None, ImageAlignment_Right);
	self.content.frame = theContentFrame;
	}

}

@end
