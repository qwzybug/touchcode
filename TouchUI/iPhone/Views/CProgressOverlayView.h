//
//  UIProgressOverlayView.h
//  EverybodyVotes
//
//  Created by Jonathan Wight on 8/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { 
	ProgressOverlayViewMode_Determinate,
	ProgressOverlayViewMode_Indeterminate,
	} EProgressOverlayViewMode;

@interface CProgressOverlayView : UIView {
	NSString *labelText;
	EProgressOverlayViewMode mode;
	UIColor *textColor;
	
	NSTimeInterval miniumDisplayTime;
	NSDate *displayTime;
	
	UIView *contentView;
	UIProgressView *progressView;
	UIActivityIndicatorView *activityIndicatorView;
	UILabel *label;

	NSTimer *timer;	
}

@property (readwrite, nonatomic, retain) NSString *labelText;
@property (readwrite, nonatomic, assign) EProgressOverlayViewMode mode;
@property (readwrite, nonatomic, retain) UIColor *textColor;
@property (readwrite, nonatomic, assign) NSTimeInterval miniumDisplayTime;
@property (readwrite, nonatomic, retain) NSDate *displayTime;
@property (readwrite, nonatomic, assign) float progress;

@property (readwrite, nonatomic, retain) UIView *contentView;
@property (readwrite, nonatomic, retain) UIProgressView *progressView;
@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (readwrite, nonatomic, retain) UILabel *label;

- (id)initWithLabel:(NSString *)inLabelText;

- (void)showWithDelay:(NSTimeInterval)inTimeInterval;
- (void)show;
- (void)hide;

@end
