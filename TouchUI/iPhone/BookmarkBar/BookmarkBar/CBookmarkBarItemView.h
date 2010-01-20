//
//  CBookmarkItemView.h
//  BookmarkBarTest
//
//  Created by Jonathan Wight on 1/3/10.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBookmarkBar;
@class CBookmarkBarItem;

@interface CBookmarkBarItemView : UIView {
	CBookmarkBar *bookmarkBar;
	CBookmarkBarItem *item;
	UILabel *label;
}

@property (readwrite, nonatomic, assign) CBookmarkBar *bookmarkBar;
@property (readwrite, nonatomic, retain) CBookmarkBarItem *item;
@property (readwrite, nonatomic, retain) UILabel *label;

@end
