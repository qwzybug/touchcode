//
//  CBookmarkBarItem.h
//  BookmarkBarTest
//
//  Created by Jonathan Wight on 1/3/10.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIBarButtonItem

@class CBookmarkBar;
@class CBookmarkBarItemView;

@interface CBookmarkBarItem : NSObject {
	CBookmarkBar *bookmarkBar;
	NSString *title;
	UIFont *font;
	UIColor *titleColor;
	UIImage *image;
	BOOL selected;
	SEL action;
	id target;
	NSInteger tag;
	id representedObject;
	id view;
}

@property (readwrite, nonatomic, assign) CBookmarkBar *bookmarkBar;
@property (readwrite, nonatomic, retain) NSString *title;
@property (readwrite, nonatomic, retain) UIFont *font;
@property (readwrite, nonatomic, retain) UIColor *titleColor;
@property (readwrite, nonatomic, retain) UIImage *image;

@property (readwrite, nonatomic, assign) BOOL selected;
@property (readwrite, nonatomic, assign) SEL action;
@property (readwrite, nonatomic, assign) id target;
@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, retain) id representedObject;
@property (readwrite, nonatomic, assign) CBookmarkBarItemView *view;

@end
