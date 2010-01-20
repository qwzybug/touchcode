//
//  CBookmarkBar.m
//  BookmarkBarTest
//
//  Created by Jonathan Wight on 1/3/10.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CBookmarkBar.h"

#import "CBookmarkBarItemView.h"
#import "CBookmarkBarItem.h"

@interface CBookmarkBar ()
@property (readwrite, nonatomic, retain) UIScrollView *scrollView;

- (CBookmarkBarItemView *)viewForItem:(CBookmarkBarItem *)inItem;
- (void)setDefaults;
@end

#pragma mark -

@implementation CBookmarkBar

@dynamic items;
@dynamic selectedItem;
@synthesize defaultItemAttributes;
@synthesize selectedItemAttributes;
@synthesize gap1;
@synthesize gap2;
@synthesize gap3;
@synthesize scrollView;

- (id)initWithFrame:(CGRect)inFrame
{
if ((self = [super initWithFrame:inFrame]) != NULL)
	{
	[self setDefaults];
	
	[self setNeedsLayout];
	}
return(self);
}

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != NULL)
	{
	[self setDefaults];
	
	[self setNeedsLayout];
	}
return(self);
}
 
- (void)dealloc
{
self.items = NULL;
self.selectedItem = NULL;
self.defaultItemAttributes = NULL;
self.selectedItemAttributes = NULL;
self.scrollView = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSArray *)items
{
return(items); 
}

- (void)setItems:(NSArray *)inItems
{
if (items != inItems)
	{
	if (items != NULL)
		{
		for (CBookmarkBarItem *theItem in items)
			theItem.bookmarkBar = NULL;
		//
		[items autorelease];
		items = NULL;
		//
		[self.scrollView removeFromSuperview];
		self.scrollView == NULL;
		}
		
	if (inItems != NULL)
		{
		items = [inItems retain];
		for (CBookmarkBarItem *theItem in items)
			{
			theItem.bookmarkBar = self;
			for (NSString *theKey in self.defaultItemAttributes)
				{
				[theItem setValue:[self.defaultItemAttributes objectForKey:theKey] forKey:theKey];
				}
			}
		//
		if ([items containsObject:self.selectedItem] == NO)
			self.selectedItem = NULL;
		
		[self.scrollView removeFromSuperview];
		self.scrollView = NULL;
		
		[self layoutSubviews];
		}
	}
}

- (CBookmarkBarItem *)selectedItem
{
return(selectedItem);
}

- (void)setSelectedItem:(CBookmarkBarItem *)inSelectedItem
{
if (selectedItem != inSelectedItem)
	{
	if (self.selectedItem)
		{
		self.selectedItem.selected = NO;

		for (NSString *theKey in self.defaultItemAttributes)
			{
			[self.selectedItem setValue:[self.defaultItemAttributes objectForKey:theKey] forKey:theKey];
			}

		CBookmarkBarItemView *theView = [self viewForItem:self.selectedItem];
		[theView layoutSubviews];
		[theView setNeedsDisplay];
		}
	
	selectedItem = inSelectedItem;

	if (self.selectedItem)
		{
		self.selectedItem.selected = YES;

		for (NSString *theKey in self.selectedItemAttributes)
			{
			[self.selectedItem setValue:[self.selectedItemAttributes objectForKey:theKey] forKey:theKey];
			}
			
		CBookmarkBarItemView *theView = [self viewForItem:self.selectedItem];
		[theView layoutSubviews];
		[theView setNeedsDisplay];
		
		const CGRect theItemFrame = theView.frame;
		const CGRect theBounds = self.bounds;
		const CGRect theScrollRect = {
			.origin = { .x = CGRectGetMidX(theItemFrame) - CGRectGetMidX(theBounds), .y = CGRectGetMidY(theItemFrame) - CGRectGetMidY(theBounds) }, 
			.size = theBounds.size
			};
				
		[self.scrollView scrollRectToVisible:theScrollRect animated:YES];
		}
	}
}

#pragma mark -

- (void)layoutSubviews
{
if (self.scrollView == NULL)
	{
	self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];

	self.scrollView.directionalLockEnabled = YES;
	self.scrollView.bounces = YES;
	self.scrollView.alwaysBounceVertical = NO;
	self.scrollView.alwaysBounceHorizontal = NO;
	self.scrollView.pagingEnabled = NO;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	
	CGSize theSize = self.bounds.size;
	
	CGRect theFrame = { .origin = { .x = self.gap1, .y = 0.0 }, .size = theSize };
	CGRect theScrollFrame = CGRectZero;
	for (CBookmarkBarItem *theBookmarkItem in self.items)
		{		
//		CBookmarkBarItemView *theBookmarkItemView = [[[CBookmarkBarItemView alloc] initWithFrame:theFrame] autorelease];
//		theBookmarkItemView.bookmarkBar = self;
//		theBookmarkItemView.item = theBookmarkItem;
//		[theBookmarkItemView sizeToFit];
//		
//		[self.scrollView addSubview:theBookmarkItemView];
//
//		theFrame.origin.x += theBookmarkItemView.frame.size.width + self.gap2;
//		theScrollFrame = CGRectUnion(theScrollFrame, theBookmarkItemView.frame);
		CGFloat theNewX = CGRectGetMaxX(theScrollFrame) + self.gap2;

		CBookmarkBarItemView *theView = theBookmarkItem.view;
		if (theView == NULL)
			{
			theView = [[self newViewForItem:theBookmarkItem] autorelease];
			
			CGRect theFrame = theView.frame;
			
			theFrame.origin.x = theNewX;
			theView.frame = theFrame;
			
			theScrollFrame = CGRectUnion(theScrollFrame, theFrame);
			
			[self.scrollView addSubview:theView];
			}

		}

	theScrollFrame.size.width += self.gap1;
	self.scrollView.contentSize = theScrollFrame.size;

	[self addSubview:self.scrollView];
	}
}

#pragma mark -

- (CBookmarkBarItemView *)newViewForItem:(CBookmarkBarItem *)inItem
{
CGRect theFrame = { .origin = CGPointZero, .size = self.bounds.size };

CBookmarkBarItemView *theBookmarkItemView = [[CBookmarkBarItemView alloc] initWithFrame:theFrame];
theBookmarkItemView.bookmarkBar = self;
theBookmarkItemView.item = inItem;
[theBookmarkItemView sizeToFit];
inItem.view = theBookmarkItemView;

return(theBookmarkItemView);
}

#pragma mark -

- (CBookmarkBarItemView *)viewForItem:(CBookmarkBarItem *)inItem;
{
NSInteger theIndex = [self.items indexOfObject:inItem];
if (theIndex != NSNotFound)
	{
	CBookmarkBarItemView *theItemView = [self.scrollView.subviews objectAtIndex:theIndex];
	return(theItemView);
	}
else
	return(NULL);
}

- (void)setDefaults
{
self.defaultItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
	[UIFont systemFontOfSize:[UIFont systemFontSize] + 3.0], @"font",
	[UIColor blackColor], @"titleColor",
	[UIColor whiteColor], @"backgroundColor",
	[UIColor redColor], @"borderColor",
	[NSNumber numberWithFloat:5.0], @"borderWidth",
	NULL];
self.selectedItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
	[UIFont systemFontOfSize:[UIFont systemFontSize] + 3.0], @"font",
	[UIColor redColor], @"titleColor",
	[UIColor whiteColor], @"backgroundColor",
	[UIColor redColor], @"borderColor",
	[NSNumber numberWithFloat:5.0], @"borderWidth",
	NULL];

gap1 = 10;
gap2 = 10;
gap3 = 10;
}

@end
