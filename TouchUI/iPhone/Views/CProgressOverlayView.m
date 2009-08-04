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

@interface CProgressOverlayView ()

@property (readwrite, nonatomic, retain) UIView *contentView;
@property (readwrite, nonatomic, retain) UIProgressView *progressView;
@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (readwrite, nonatomic, retain) UILabel *label;

@property (readwrite, nonatomic, assign) NSTimer *displayTimer;
@property (readwrite, nonatomic, assign) NSTimer *fadeTimer;

@end

#pragma mark -

@implementation CProgressOverlayView

#define HUD_SIZE 150.0f
#define FADE_TIME 0.025f
#define BACKGROUND_COLOR [UIColor colorWithWhite:0.0 alpha:0.8]

static CProgressOverlayView *gInstance = NULL;
// UIAlertView

@synthesize labelText;
@synthesize mode;
@synthesize size;
@synthesize miniumDisplayTime;
@synthesize displayTime;
@dynamic progress;
@synthesize contentView;
@synthesize progressView;
@synthesize activityIndicatorView;
@synthesize label;
@synthesize displayTimer;
@synthesize fadeTimer;

+ (CProgressOverlayView *)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super initWithFrame:CGRectZero]) != NULL)
	{
    self.backgroundColor = [UIColor clearColor];
    self.miniumDisplayTime = 1.0;

	self.mode = ProgressOverlayViewMode_Indeterminate;
    self.size = ProgressOverlayViewSizeFull;
	}
return(self);
}

- (void)dealloc
{
[self.displayTimer invalidate];
self.displayTimer = NULL;

[self.fadeTimer invalidate];
self.fadeTimer = NULL;

self.displayTime = NULL;
self.labelText = NULL;
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
	self.label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	self.label.textColor = [UIColor whiteColor];
	self.label.shadowColor = [UIColor blackColor];
	self.label.shadowOffset = CGSizeMake(0, 1);
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

- (void)drawRect:(CGRect)inRect
{
if (self.size == ProgressOverlayViewSizeHUD)
    {
    UIColor *color = [UIColor colorWithWhite:0.0 alpha:0.8];
    
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

#pragma mark -

- (void)update
{
[self.contentView removeFromSuperview];

[self.displayTimer invalidate];
self.displayTimer = NULL;

[self.fadeTimer invalidate];
self.fadeTimer = NULL;
    
self.displayTime = NULL;
self.contentView = NULL;
self.progressView = NULL;
self.activityIndicatorView = NULL;
self.label = NULL;

[self layoutSubviews];
}

- (void)showInView:(UIView *)inView withDelay:(NSTimeInterval)inTimeInterval;
{
NSInvocation *theInvocation = NULL;
[[self grabInvocation:&theInvocation] showInView:inView];
[theInvocation retainArguments];

self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:inTimeInterval invocation:theInvocation repeats:NO];
}

- (void)showInView:(UIView *)inView
{
if (self.displayTimer)
	{
	[self.displayTimer invalidate];
	self.displayTimer = NULL;
	}

if (self.mode == ProgressOverlayViewMode_Determinate)
    self.size = ProgressOverlayViewSizeFull;

if (self.size == ProgressOverlayViewSizeFull)
    self.backgroundColor = BACKGROUND_COLOR;

UIView *theView = NULL;

if (inView)
	{
	theView = inView;
        
    if (self.size = ProgressOverlayViewSizeHUD)
        {
        // HUD placement
        CGRect viewFrame = theView.bounds;
		self.bounds = CGRectMake(0, 0, HUD_SIZE, HUD_SIZE);
		self.center = CGPointMake(floorf(theView.bounds.size.width/2), floorf(theView.bounds.size.height/2));
        // touch guard behind HUD
        guardView = [[UIView alloc] initWithFrame:viewFrame];
        guardView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [theView addSubview:guardView];
        [guardView release];
        }
    else
        self.frame = [inView convertRect:inView.bounds toView:theView];
	}
else
	{
	theView = [UIApplication sharedApplication].keyWindow;
        
    if (self.size == ProgressOverlayViewSizeHUD)
        {
        // HUD placement
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        self.frame = CGRectMake(((appFrame.size.width / 2) - (HUD_SIZE / 2)), ((appFrame.size.height / 2) - (HUD_SIZE / 2)), HUD_SIZE, HUD_SIZE);
        // touch guard behind HUD
        guardView = [[UIView alloc] initWithFrame:appFrame];
        guardView.backgroundColor = [UIColor clearColor];
        [theView addSubview:guardView];
        [guardView release];
        }
    else
        self.frame = [UIScreen mainScreen].applicationFrame;
    }
[self setNeedsLayout];

[theView addSubview:self];

self.displayTime = [NSDate date];

self.alpha = 0.0;
self.fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:FADE_TIME target:self selector:@selector(fadeIn:) userInfo:nil repeats:YES] retain];
}

- (void)hide
{
if (self.displayTimer)
	{
	[self.displayTimer invalidate];
	self.displayTimer = NULL;
	}

if (self.fadeTimer)
    {
    [self.fadeTimer invalidate];
    self.fadeTimer = NULL;
    }
    
if (self.superview != NULL)
	{
	NSTimeInterval theDelta = -[self.displayTime timeIntervalSinceNow];
	if (theDelta < self.miniumDisplayTime)
		{
		[self retain];
		do
			{
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
			}
		while ((-[self.displayTime timeIntervalSinceNow]) < self.miniumDisplayTime)
			;
		[self autorelease];
		}
    self.fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:FADE_TIME target:self selector:@selector(fadeOut:) userInfo:nil repeats:YES] retain];
	}
}

- (void)fadeIn:(NSTimer *)theTimer
{
    if (self.alpha >= 1.0)
        {
        [theTimer invalidate];
        theTimer = NULL;
        }
    else
        self.alpha += 0.1;
}

- (void)fadeOut:(NSTimer *)theTimer
{
    if (self.alpha <= 0.1)
        {
        [theTimer invalidate];
        theTimer = NULL;
        [guardView removeFromSuperview];
        [self removeFromSuperview];
        }
    else
        self.alpha -= 0.1;
}

@end