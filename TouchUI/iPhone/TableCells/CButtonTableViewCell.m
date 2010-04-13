//
//  CButtonTableViewCell.m
//  touchcode
//
//  Created by Jonathan Wight on 5/8/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CButtonTableViewCell.h"

#import "CGlossyButton.h"

@interface CButtonTableViewCell ()
- (IBAction)actionTapped:(id)inSender;
@end

#pragma mark -

@implementation CButtonTableViewCell

@synthesize button;
@synthesize target;
@synthesize action;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) != NULL)
	{
	[self layoutSubviews];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	}
return(self);
}

- (void)dealloc
{
self.button = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)layoutSubviews
{
[super layoutSubviews];

if (self.button == NULL)
	{
	self.button = [CGlossyButton buttonWithTitle:@"TODO" target:self action:@selector(actionTapped:)];
	self.button.frame = self.contentView.bounds;
	[self.contentView addSubview:self.button];
	}
}

- (IBAction)actionTapped:(id)inSender
{
[self.target performSelector:self.action withObject:self];
}


@end
