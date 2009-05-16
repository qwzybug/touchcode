//
//  UIView_LayoutExtensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	LayoutMethod_MakeColumn,
} ELayoutMethod;


@interface UIView (UIView_LayoutExtensions)

- (void)layoutSubviewsUsingMethod:(ELayoutMethod)inMethod;
- (void)adjustFrameToFramesOfSubviews;
- (void)dumpViewTree;
- (void)dumpViewTree:(int)inCurrentDepth maxDepth:(int)inMaxDepth;

@end
