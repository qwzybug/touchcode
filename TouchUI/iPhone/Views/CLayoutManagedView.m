//
//  CLayoutManagedView.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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
