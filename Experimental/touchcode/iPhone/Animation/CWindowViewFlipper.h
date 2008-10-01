//
//  CWindowViewFlipper.h
//  TouchCode
//
//  Created by Jonathan Wight on 05/30/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWindowViewFlipper : NSObject {
	UIView *viewOne;
	UIView *viewTwo;
	UIViewAnimationTransition transition;
}

@property (readwrite, nonatomic, retain) UIView *viewOne;
@property (readwrite, nonatomic, retain) UIView *viewTwo;
@property (readwrite, nonatomic, assign) UIViewAnimationTransition transition;

- (void)flipView:(UIView *)inViewOne toView:(UIView *)inViewTwo;
- (void)flip;

@end
