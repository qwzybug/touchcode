//
//  CFullScreenView.h
//  PlateView
//
//  Created by Jonathan Wight on 1/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFullScreenView : UIView {
	NSArray *autoHideViews;
	BOOL autoHideStatusBar;
	NSTimer *autoHideTimer;
	NSTimeInterval autoHideDelay;
}

/// Array of UIViews to be automatically hidden after a preset delay following this view being added to a view hierarchy. Usually you should populate this with the current UINavigationBar and (any) UIToolbar. Calling showUI will reset the delay timer. You could do this when the user taps in this view (or possibly anywhere on the screen - ICK)
@property (readwrite, nonatomic, retain) NSArray *autoHideViews;
@property (readwrite, nonatomic, assign) BOOL autoHideStatusBar;
@property (readwrite, nonatomic, assign) NSTimeInterval autoHideDelay;

- (void)showUI;
- (void)hideUI;

@end
