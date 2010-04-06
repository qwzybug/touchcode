//
//  UIView_AnimationExtensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 10/9/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ViewAnimationType_SlideDown,
	ViewAnimationType_SlideUp,
	ViewAnimationType_SlideLeft,
	ViewAnimationType_SlideRight,
	ViewAnimationType_FadeIn,
	ViewAnimationType_FadeOut,
} EViewAnimationType;

@interface UIView (UIView_AnimationExtensions)

- (void)addSubview:(UIView *)inSubview withAnimationType:(EViewAnimationType)inAnimationType;
- (void)removeFromSuperviewWithAnimationType:(EViewAnimationType)inAnimationType;

@end
