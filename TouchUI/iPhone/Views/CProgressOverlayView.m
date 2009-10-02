//
//  CProgressOverlayView.m
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

#import "CProgressOverlayView.h"

#import "Geometry.h"
#import "NSObject_InvocationGrabberExtensions.h"
#import "UIViewDebugging.h"

@interface CProgressOverlayView ()

@property (readwrite, nonatomic, retain) UIView *contentView;
@property (readwrite, nonatomic, retain) UIProgressView *progressView;
@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (readwrite, nonatomic, retain) UILabel *label;

@property (readwrite, nonatomic, assign) NSTimer *displayTimer;
@property (readwrite, nonatomic, assign) NSTimer *hideTimer;

- (void)layoutInView:(UIView *)inView;
- (void)positionHUDInView:(UIView *)theView;

@end

#pragma mark -

@implementation CProgressOverlayView

static CProgressOverlayView *gInstance = NULL;

@synthesize labelText;
@synthesize progressMode;
@synthesize size;
@synthesize guardColor;
@synthesize displayDelayTime;
@synthesize minimumDisplayTime;
@synthesize displayTime;
@dynamic progress;
@synthesize contentView;
@synthesize progressView;
@synthesize activityIndicatorView;
@synthesize label;
@synthesize displayTimer;
@synthesize hideTimer;
@dynamic showing;

+ (CProgressOverlayView *)instance
{
@synchronized(@"CProgressOverlayView")
	{
	if (gInstance == NULL)
		{
		gInstance = [[self alloc] init];
		}
	}
return(gInstance);
}

- (id)init
{
if ((self = [super initWithFrame:CGRectZero]) != NULL)
	{
    self.backgroundColor = [UIColor clearColor];

	self.labelText = NULL;
	self.progressMode = ProgressOverlayViewProgressModeIndeterminate;
    self.size = ProgressOverlayViewSizeFull;
//    self.fadeMode = ProgressOverlayViewFadeModeNone;
//	self.showDelayTime = 1.0;
//	self.hideDelayTime = 0.1;
    self.minimumDisplayTime = 1.0;
	}
return(self);
}

- (void)dealloc
{
if (displayTimer)
	{
	[displayTimer invalidate];
	displayTimer = NULL;
	}
if (hideTimer)
	{
	[hideTimer invalidate];
	hideTimer = NULL;
	}


self.displayTime = NULL;
self.labelText = NULL;
self.contentView = NULL;
self.progressView = NULL;
self.activityIndicatorView = NULL;
self.label = NULL;
self.guardColor = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)labelText
{
return(labelText); 
}

- (void)setLabelText:(NSString *)inLabelText
{
if (labelText != inLabelText)
	{
	[labelText release];
	labelText = [inLabelText retain];

	if (self.label)
		self.label.text = labelText;
    }
}

- (float)progress
{
return(self.progressView.progress);
}

- (void)setProgress:(float)inProgress
{
self.progressView.progress = inProgress;
}

- (BOOL)showing
{
return(self.superview != NULL);
}

#pragma mark -

- (void)drawRect:(CGRect)inRect
{
if (self.size == ProgressOverlayViewSizeHUD)
    {
    UIColor *color = PROGRESS_OVERLAY_VIEW_BACKGROUND_COLOR;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);

    CGRect rect = self.bounds;

    CGFloat radius = 15.0;
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minx, midy);
    
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    }
#if 0
// FOR DEBUGGING ONLY (and for people who like red outlines)

CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor redColor].CGColor);
CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.bounds);
#endif
}

#pragma mark -

- (void)layoutInView:(UIView *)inView
{
if (self.size == ProgressOverlayViewSizeHUD)
	[self positionHUDInView:inView];
else
	self.frame = inView.bounds;

if (self.progressMode == ProgressOverlayViewProgressModeDeterminate)
    self.size = ProgressOverlayViewSizeFull;

if (self.size == ProgressOverlayViewSizeFull)
    self.backgroundColor = PROGRESS_OVERLAY_VIEW_BACKGROUND_COLOR;

if (self.contentView == NULL)
	{
	self.contentView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	[self addSubview:self.contentView];
	}

if (self.progressMode == ProgressOverlayViewProgressModeDeterminate && self.progressView == NULL)
	{
	self.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
	self.progressView.progress = 0.0;
	[self.contentView addSubview:self.progressView];
	}

if (self.progressMode == ProgressOverlayViewProgressModeIndeterminate && self.activityIndicatorView == NULL)
	{
	self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	[self.activityIndicatorView startAnimating];
	[self.contentView addSubview:self.activityIndicatorView];
	}

if (self.label == NULL)
	{
	self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	self.label.textAlignment = UITextAlignmentCenter;
	self.label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	self.label.textColor = [UIColor whiteColor];
	self.label.shadowColor = [UIColor blackColor];
	self.label.shadowOffset = CGSizeMake(0, 1);
	self.label.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:self.label];
	self.label.text = self.labelText;
	}

if (self.progressMode == ProgressOverlayViewProgressModeDeterminate)
	{
	CGRect theContentViewFrame = CGRectMake(0, 0, 280, 49);
	self.contentView.frame = ScaleAndAlignRectToRect(theContentViewFrame, self.bounds, ImageScaling_None, ImageAlignment_Center);
	self.progressView.frame = CGRectMake(0, 0, 280, 9);
	self.label.frame = CGRectMake(0, 29, 280, 20);
	}
else if (self.progressMode == ProgressOverlayViewProgressModeIndeterminate)
	{
	CGRect theContentViewFrame = CGRectMake(0, 0, 280, 66);
	self.contentView.frame = ScaleAndAlignRectToRect(theContentViewFrame, self.bounds, ImageScaling_None, ImageAlignment_Center);
	self.activityIndicatorView.frame = CGRectMake(121, 0, 37, 37);
	self.label.frame = CGRectMake(0, 45, 280, 20);
	}
}

- (void)update
{
[self.contentView removeFromSuperview];

if (displayTimer)
	{
	[displayTimer invalidate];
	displayTimer = NULL;
	}
if (hideTimer)
	{
	[hideTimer invalidate];
	hideTimer = NULL;
	}

self.displayTime = NULL;
self.contentView = NULL;
self.progressView = NULL;
self.activityIndicatorView = NULL;
self.label = NULL;

[self layoutInView:NULL];
}

//- (void)showInView:(UIView *)inView withDelay:(NSTimeInterval)inTimeInterval labelText:(NSString *)inLabelText
//{
//if ([NSThread isMainThread] == NO)
//	{
//	[[self grabInvocationAndPerformOnMainThreadWaitUntilDone:YES] showInView:inView withDelay:inTimeInterval labelText:inLabelText];
//	return;
//	}
//
//if (self.showing && [inLabelText isEqualToString:self.labelText])
//	return;
//
//self.displayDelayTime = inTimeInterval;
//self.labelText = inLabelText;
//[self showInView:inView withDelay:self.displayDelayTime];
//}
//
//- (void)showInView:(UIView *)inView withDelay:(NSTimeInterval)inTimeInterval;
//{
//if ([NSThread isMainThread] == NO)
//	{
//	[[self grabInvocationAndPerformOnMainThreadWaitUntilDone:YES] showInView:inView withDelay:inTimeInterval];
//	return;
//	}
//
//NSInvocation *theInvocation = NULL;
//[[self grabInvocation:&theInvocation] showInView:inView];
//[theInvocation retainArguments];
//
//self.displayDelayTime = inTimeInterval;
//self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:self.displayDelayTime invocation:theInvocation repeats:NO];
//}

- (void)showInView:(UIView *)inView
{
if ([NSThread isMainThread] == NO)
	{
	[[self grabInvocationAndPerformOnMainThreadWaitUntilDone:YES] showInView:inView];
	return;
	}

if (self.displayTimer)
	{
	[self.displayTimer invalidate];
	self.displayTimer = NULL;
	}

UIView *theView = NULL;

if (inView)
	{
	theView = inView;
	}
else
	{
	theView = [UIApplication sharedApplication].keyWindow;
    }
	
[self layoutInView:theView];

[theView addSubview:self];

self.displayTime = [NSDate date];
}

- (void)hide
{
if ([NSThread isMainThread] == NO)
	{
	[[self grabInvocationAndPerformOnMainThreadWaitUntilDone:YES] hide];
	return;
	}

if (self.superview != NULL)
	{
	if (self.displayTimer)
		{
		[self.displayTimer invalidate];
		self.displayTimer = NULL;
		}

	NSDate *theHideTime = [self.displayTime addTimeInterval:self.minimumDisplayTime];
	NSTimeInterval theHideInterval = [theHideTime timeIntervalSinceDate:[NSDate date]];
	if (theHideInterval > 0.0)
		{
		[self.hideTimer invalidate];
		self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:theHideInterval target:self selector:@selector(hideTimer:) userInfo:NULL repeats:NO];
		
		return;
		}

	if (self.superview != NULL)
		{
		[guardView removeFromSuperview];
		[self removeFromSuperview];
		}
	}
}

#pragma mark -

- (void)positionHUDInView:(UIView *)theView
{
// HUD placement
self.bounds = CGRectMake(0, 0, PROGRESS_OVERLAY_VIEW_HUD_SIZE, PROGRESS_OVERLAY_VIEW_HUD_SIZE);
self.center = CGPointMake(floorf(theView.bounds.size.width / 2), floorf(theView.bounds.size.height / 2));
// touch guard behind HUD
guardView = [[UIView alloc] initWithFrame:theView.frame];
guardView.backgroundColor = (self.guardColor ? self.guardColor : [UIColor clearColor]);
[theView addSubview:guardView];
[guardView release];
}

#pragma mark -

- (void)displayTimer:(id)inParameter
{
displayTimer = NULL;

}

- (void)hideTimer:(id)inParameter
{
NSLog(@"HIDE TIMER FIRE");

hideTimer = NULL;
//
[self hide];
}

@end