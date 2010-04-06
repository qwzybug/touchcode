//
//  CBookmarkItemView.m
//  BookmarkBarTest
//
//  Created by Jonathan Wight on 1/3/10.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CBookmarkBarItemView.h"

#import "CBookmarkBar.h"
#import "CBookmarkBarItem.h"

@interface CBookmarkBarItemView ()
@end

#pragma mark -

@implementation CBookmarkBarItemView

@synthesize bookmarkBar;
@dynamic item;
@synthesize label;

+ (CBookmarkBarItemView *)bookmarkBarItemView
{
CBookmarkBarItemView *theItem = [self buttonWithType:UIButtonTypeCustom];
theItem.adjustsImageWhenHighlighted = NO;
theItem.adjustsImageWhenDisabled = NO;
theItem.showsTouchWhenHighlighted = YES;
return(theItem);
}

- (void)dealloc
{
self.item = NULL;
self.label = NULL;
//
[super dealloc];
}

#pragma mark -

- (CBookmarkBarItem *)item
{
return(item); 
}

- (void)setItem:(CBookmarkBarItem *)inItem
{
if (item != inItem)
	{
	[item autorelease];
	item = [inItem retain];

	[self setNeedsLayout];
	}
}

#pragma mark -
- (void)layoutSubviews
{
[super layoutSubviews];
//
if (self.label == NULL)
	{
	self.label = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
	self.label.backgroundColor = [UIColor clearColor];
	
	[self addSubview:self.label];
	}

self.label.text = self.item.title;
self.label.textColor = self.item.titleColor;
self.label.font = self.item.font;
}

- (void)sizeToFit
{
[super sizeToFit];
[self layoutIfNeeded];

CGFloat theSavedHeight = self.label.frame.size.height;
[self.label sizeToFit];
CGRect theFrame = self.label.frame;
theFrame.origin.x += self.bookmarkBar.gap3;
theFrame.size.height = theSavedHeight;
self.label.frame = theFrame;


theFrame = self.frame;
theFrame.size.width = self.label.bounds.size.width + self.bookmarkBar.gap3 * 2;
self.frame = theFrame;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
{
[super endTrackingWithTouch:touch withEvent:event];

SEL theAction = self.item.action;
id theTarget = self.item.target;
self.bookmarkBar.selectedItem = self.item;

if (theTarget && theAction && [theTarget respondsToSelector:theAction])
	{
	[theTarget performSelector:theAction withObject:self.item];
	}
}

- (void)update
{
NSLog(@"UPDATE: %@", self.item.image);

[self setBackgroundImage:self.item.image forState:UIControlStateNormal];

[self layoutSubviews];
[self setNeedsDisplay];
}

@end
