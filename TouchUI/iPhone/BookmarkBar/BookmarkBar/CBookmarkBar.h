//
//  CBookmarkBar.h
//  BookmarkBarTest
//
//  Created by Jonathan Wight on 1/3/10.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBookmarkBarItem;
@class CBookmarkBarItemView;

@interface CBookmarkBar : UIView {
	NSArray *items;
	CBookmarkBarItem *selectedItem;
	//
	NSDictionary *defaultItemAttributes;
	NSDictionary *selectedItemAttributes;
	//
	CGFloat gap1;
	CGFloat gap2;
	CGFloat gap3;
	CGFloat bottomBorderHeight;
	
	
	UIScrollView *scrollView;
}

@property (readwrite, nonatomic, retain) NSArray *items;
@property (readwrite, nonatomic, retain) CBookmarkBarItem *selectedItem;

@property (readwrite, nonatomic, retain) NSDictionary *defaultItemAttributes;
@property (readwrite, nonatomic, retain) NSDictionary *selectedItemAttributes;

@property (readonly, nonatomic, assign) CGFloat gap1;
@property (readonly, nonatomic, assign) CGFloat gap2;
@property (readonly, nonatomic, assign) CGFloat gap3;
@property (readonly, nonatomic, assign) CGFloat bottomBorderHeight;

@property (readonly, nonatomic, retain) UIScrollView *scrollView;

- (CBookmarkBarItemView *)newViewForItem:(CBookmarkBarItem *)inItem;

@end
