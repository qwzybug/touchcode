//
//  CTitleLabelTableViewCell.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/31/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CLabelledValueTableViewCell.h"

#import "Geometry.h"

@implementation CLabelledValueTableViewCell

@synthesize textLabel = outletTextLabel;
@dynamic valueView;
@dynamic placeholderText;

+ (CLabelledValueTableViewCell *)cell
{
NSArray *theObjects = [[NSBundle mainBundle] loadNibNamed:@"LabelledValueTableViewCell" owner:self options:NULL];
CLabelledValueTableViewCell *theCell = [theObjects objectAtIndex:1];
return(theCell);
}

- (void)dealloc
{
self.textLabel = NULL;
self.valueView = NULL;
self.placeholderText = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)setText:(NSString *)inText
{
[super setText:inText];

[self layoutSubviews];
}

- (UIView *)valueView
{
return(valueView); 
}

- (void)setValueView:(UIView *)inValueView
{
if (valueView != inValueView)
	{
	if (valueView != NULL)
		{
		[valueView removeFromSuperview];
		//
		[valueView autorelease];
		valueView = NULL;
		}
		
	if (inValueView)
		{
		valueView = [inValueView retain];
		//
		[self.contentView addSubview:valueView];
		}
    }
}

- (NSString *)placeholderText
{
return(placeholderText); 
}

- (void)setPlaceholderText:(NSString *)inPlaceholderText
{
if (placeholderText != inPlaceholderText)
	{
	[placeholderText autorelease];
	placeholderText = [inPlaceholderText retain];
	
	[self layoutSubviews];
    }
}

- (void)layoutSubviews
{
[super layoutSubviews];

if (self.placeholderText != NULL && (self.text == NULL || self.text.length == 0))
	{
	self.textLabel.text = placeholderText;
	self.textLabel.font = [UIFont boldSystemFontOfSize:14];
	self.textLabel.textColor = [UIColor colorWithRed:0.318 green:0.40 blue:0.569 alpha:1.0];
	}
else
	{
	self.textLabel.text = self.text;
	self.textLabel.font = self.font;
	self.textLabel.textColor = self.textColor;
	}

CGRect theContentBounds = self.contentView.bounds;
theContentBounds = CGRectInset(theContentBounds, 18.0, 0.0);

self.textLabel.frame = ScaleAndAlignRectToRect(self.textLabel.frame, theContentBounds, ImageScaling_ToFit, ImageAlignment_Left);
if (self.valueView != NULL)
	self.valueView.frame = ScaleAndAlignRectToRect(self.valueView.frame, theContentBounds, ImageScaling_None, ImageAlignment_Right);
}

@end

#pragma mark -

@implementation CLabelledValueTableViewCell (CLabelledValueTableViewCell_ConvenienceExtensions)

@dynamic valueLabel;

- (UILabel *)valueLabel
{
if (self.valueView == NULL)
	{
	self.valueLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	}

return(NULL);
}

- (void)setValueLabel:(UILabel *)inValueLabel
{
self.valueView = inValueLabel;
}

@end