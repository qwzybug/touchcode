//
//  CLayoutManagedView.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CLayoutManagedView.h"

@implementation CLayoutManagedView

- (void)addSubview:(UIView *)inSubview
{
[super addSubview:inSubview];
[self adjustLayout];
}

- (void)setFrame:(CGRect)inFrame
{
[super setFrame:inFrame];
[self adjustLayout];
}

- (void)adjustLayout
{
CGRect theSubviewFrame = { .origin = CGPointZero, .size = { .width = [self bounds].size.width, [self bounds].size.height / self.subviews.count } };
for (UIView *theSubview in self.subviews)
	{
	theSubview.frame = theSubviewFrame;
	
	theSubviewFrame.origin.y += theSubviewFrame.size.height;
	}
}

@end

#pragma mark -

@implementation CLayoutManagedView (Convenience_Extensions)

- (void)addLabelsWithTitles:(NSArray *)inTitles properties:(NSDictionary *)inProperties
{
for (NSString *theTitle in inTitles)
	{
	UILabel *theLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	theLabel.text = theTitle;
	theLabel.adjustsFontSizeToFitWidth = YES;
	for (NSString *theKey in inProperties)
		{
		id theValue = [inProperties objectForKey:theKey];
		[theLabel setValue:theValue forKey:theKey];
		}
	
	[self addSubview:theLabel];
	}
}

- (void)setHighlighted:(BOOL)inHighlighted
{
for (id theSubview in self.subviews)
	{
	if ([theSubview respondsToSelector:@selector(setHighlighted:)])
		[theSubview setHighlighted:inHighlighted];
	}
}

@end