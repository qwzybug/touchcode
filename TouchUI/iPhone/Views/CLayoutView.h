//
//  CLayoutView.h
//  TouchCode
//
//  Created by Jonathan Wight on 10/12/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	LayoutMode_VerticalStack,
	LayoutMode_HorizontalStack,
	}
	ELayoutMode;

@interface CLayoutView : UIView {
	ELayoutMode mode;
	CGSize gap;
	BOOL flexibleLastView;
	BOOL fitViews;
	UIView *flexibleView;
}

@property (readwrite, nonatomic, assign) ELayoutMode mode;
@property (readwrite, nonatomic, assign) CGSize gap;
@property (readwrite, nonatomic, assign) BOOL flexibleLastView;
@property (readwrite, nonatomic, assign) BOOL fitViews;
@property (nonatomic, assign) UIView *flexibleView;

@end
