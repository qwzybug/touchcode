//
//  UIProgressOverlayView.m
//  EverybodyVotes
//
//  Created by Jonathan Wight on 8/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CProgressOverlayView.h"

#import "Geometry.h"
#import "NSObject_InvocationGrabberExtensions.h"

@interface CProgressOverlayView ()

@property (readwrite, nonatomic, assign) NSTimer *timer;

@end

#pragma mark -

@implementation CProgressOverlayView

// UIAlertView

@synthesize labelText;
@synthesize mode;
@synthesize textColor;
@synthesize miniumDisplayTime;
@synthesize displayTime;
@dynamic progress;
@synthesize contentView;
@synthesize progressView;
@synthesize activityIndicatorView;
@synthesize label;
@synthesize timer;

- (id)initWithLabel:(NSString *)inLabelText;
{
CGRect theViewFrame = [UIScreen mainScreen].applicationFrame;

theViewFrame = CGRectInset(theViewFrame, 0, 40);


if ((self = [super initWithFrame:theViewFrame]) != NULL)
	{
	self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
	self.textColor = [UIColor whiteColor]; 
	self.labelText = inLabelText;	
	self.miniumDisplayTime = 1.0;
	
	self.mode = ProgressOverlayViewMode_Indeterminate;
	}
return(self);
}

- (void)dealloc
{
[self.timer invalidate];
self.timer = NULL;

self.displayTime = NULL;
self.labelText = NULL;
self.textColor = NULL;
self.contentView = NULL;
self.progressView = NULL;
self.activityIndicatorView = NULL;
self.label = NULL;
//
[super dealloc];
}

- (void)layoutSubviews
{
if (self.contentView == NULL)
	{
	self.contentView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	[self addSubview:self.contentView];
	}

if (self.mode == ProgressOverlayViewMode_Determinate && self.progressView == NULL)
	{
	self.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
	self.progressView.progress = 0.0;
	[self.contentView addSubview:self.progressView];
	}

if (self.mode == ProgressOverlayViewMode_Indeterminate && self.activityIndicatorView == NULL)
	{
	self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	[self.activityIndicatorView startAnimating];
	[self.contentView addSubview:self.activityIndicatorView];
	}

if (self.label == NULL)
	{
	self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	self.label.textAlignment = UITextAlignmentCenter;
	self.label.textColor = self.textColor;
	self.label.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:self.label];
	self.label.text = self.labelText;
	}
	
if (self.mode == ProgressOverlayViewMode_Determinate)
	{
	CGRect theContentViewFrame = CGRectMake(0, 0, 280, 49);
	self.contentView.frame = ScaleAndAlignRectToRect(theContentViewFrame, self.bounds, ImageScaling_None, ImageAlignment_Center);
	self.progressView.frame = CGRectMake(0, 0, 280, 9);
	self.label.frame = CGRectMake(0, 29, 280, 20);
	}
else if (self.mode == ProgressOverlayViewMode_Indeterminate)
	{
	CGRect theContentViewFrame = CGRectMake(0, 0, 280, 66);
	self.contentView.frame = ScaleAndAlignRectToRect(theContentViewFrame, self.bounds, ImageScaling_None, ImageAlignment_Center);
	self.activityIndicatorView.frame = CGRectMake(121, 0, 37, 37);
	self.label.frame = CGRectMake(0, 45, 280, 20);
	}
}

#if 0
// FOR DEBUGGING ONLY (and for people who like red outlines)
- (void)drawRect:(CGRect)inRect
{
CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor redColor].CGColor);
CGContextStrokeRect(UIGraphicsGetCurrentContext(), self.bounds);
}
#endif

#pragma mark -

- (float)progress
{
return(self.progressView.progress);
}

- (void)setProgress:(float)inProgress
{
self.progressView.progress = inProgress;
}

#pragma mark -

- (void)showWithDelay:(NSTimeInterval)inTimeInterval
{
NSInvocation *theInvocation = NULL;
[[self grabInvocation:&theInvocation] show];
[theInvocation retainArguments];

self.timer = [NSTimer scheduledTimerWithTimeInterval:inTimeInterval invocation:theInvocation repeats:NO];
}

- (void)show
{
if (self.timer)
	{
	[self.timer invalidate];
	self.timer = NULL;
	}

[self setNeedsLayout];

UIWindow *theWindow = [UIApplication sharedApplication].keyWindow;
[theWindow addSubview:self];

self.displayTime = [NSDate date];
}

- (void)hide
{
if (self.timer)
	{
	[self.timer invalidate];
	self.timer = NULL;
	}

if (self.superview != NULL)
	{
	NSTimeInterval theDelta = -[self.displayTime timeIntervalSinceNow];
	if (theDelta < self.miniumDisplayTime)
		{
		[self retain];
		NSRunLoop *theRunLoop = [NSRunLoop currentRunLoop];
		do
			{
			[theRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
			}
		while ((theDelta = -[self.displayTime timeIntervalSinceNow]) < self.miniumDisplayTime);
		[self autorelease];
		}

	[self removeFromSuperview];
	}
}

@end
