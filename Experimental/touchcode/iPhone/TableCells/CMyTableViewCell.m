//
//  CMyTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CMyTableViewCell.h"

@implementation CMyTableViewCell

@dynamic content;

- (id)initWithFrame:(CGRect)frame
{
if ((self = [super initWithFrame:frame]) != NULL)
	{
	}
return(self);
}

- (void)dealloc
{
self.content = NULL;

[super dealloc];
}

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

- (void)setFrame:(CGRect)inFrame
{
[super setFrame:inFrame];
[self adjustLayout];
}

- (void)setSelected:(BOOL)selected
{
[super setSelected:selected];

if ([self.content respondsToSelector:@selector(setHighlighted:)])	
	[(id)self.content setHighlighted:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
[super setSelected:selected animated:animated];

if ([self.content respondsToSelector:@selector(setHighlighted:)])	
	[(id)self.content setHighlighted:selected];
}

- (void)adjustLayout
{
CGRect theContentFrame = CGRectInset(self.bounds, 18, 6);


self.content.frame = theContentFrame;
}

@end
