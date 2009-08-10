//
//  CProgressOverlayView.h
//  TouchCode
//
//  Created by Jonathan Wight on 8/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

#define PROGRESS_OVERLAY_VIEW_HUD_SIZE         150.0f
#define PROGRESS_OVERLAY_VIEW_FADE_TIME        0.025f
#define PROGRESS_OVERLAY_VIEW_BACKGROUND_COLOR [UIColor colorWithWhite:0.0 alpha:0.8]

typedef enum {
	ProgressOverlayViewProgressModeDeterminate,
	ProgressOverlayViewProgressModeIndeterminate,
	} ProgressOverlayViewProgressMode;

typedef enum {
    ProgressOverlayViewSizeFull,
    ProgressOverlayViewSizeHUD,
    } ProgressOverlayViewSize;

typedef enum {
    ProgressOverlayViewFadeModeIn,
    ProgressOverlayViewFadeModeOut,
    ProgressOverlayViewFadeModeInOut,
    ProgressOverlayViewFadeModeNone,
    } ProgressOverlayViewFadeMode;

@interface CProgressOverlayView : UIView {
	NSString *labelText;                            // label text
	ProgressOverlayViewProgressMode progressMode;   // determinate or indeterminate style (can't use determinate with HUD)
    ProgressOverlayViewSize size;                   // full screen/view or rounded rectangle HUD
    ProgressOverlayViewFadeMode fadeMode;           // fade in, out, both, or none
    
	NSTimeInterval minimumDisplayTime;              // show for at least this long
	NSDate *displayTime;
	
	UIView *contentView;
	UIProgressView *progressView;
	UIActivityIndicatorView *activityIndicatorView;
	UILabel *label;

    UIView *guardView;
    UIColor *guardColor;                            // for HUD, touch guard underlay color (defaults to clear)
    
	NSTimer *displayTimer;
    NSTimer *fadeTimer;
}

@property (readwrite, nonatomic, retain) NSString *labelText;
@property (readwrite, nonatomic, assign) ProgressOverlayViewProgressMode progressMode;
@property (readwrite, nonatomic, assign) ProgressOverlayViewSize size;
@property (readwrite, nonatomic, assign) ProgressOverlayViewFadeMode fadeMode;
@property (readwrite, nonatomic, retain) UIColor *guardColor;
@property (readwrite, nonatomic, assign) NSTimeInterval minimumDisplayTime;
@property (readwrite, nonatomic, retain) NSDate *displayTime;
@property (readwrite, nonatomic, assign) float progress;

+ (CProgressOverlayView *)instance;

- (void)update;

- (void)showInView:(UIView *)inView withDelay:(NSTimeInterval)inTimeInterval; // activation after a delay (recommended to turn off fading)
- (void)showInView:(UIView *)inView;                                          // activation
- (void)hide;                                                                 // deactivation

@end