//
//  CLocationLayer.m
//  TouchCode
//
//  Created by Jonathan Wight on 06/19/08.
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

#import "CLocationLayer.h"

#import "CBetterLocationManager.h"
#import "CMap.h"
#import "Geometry.h"

static NSString *kLocationChanged = @"kLocationChanged";
static NSString *kLocationUpdating = @"kLocationUpdating";
static NSString *kMapLevelOfDetailChanged = @"kMapLevelOfDetailChanged";

@implementation CLocationLayer

@synthesize map;
@dynamic accuracyRadius;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.frame = CGRectMake(0, 0, 128, 128);
	[self setNeedsDisplay];
	self.needsDisplayOnBoundsChange = YES;
	self.zPosition = 1.0;
	
	[[CBetterLocationManager instance] addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:kLocationChanged];
	[[CBetterLocationManager instance] addObserver:self forKeyPath:@"updating" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:kLocationUpdating];
	observing = YES;
	}
return(self);
}

- (void)dealloc
{
if (observing)
	{
	[[CBetterLocationManager instance] removeObserver:self forKeyPath:@"location"];
	[[CBetterLocationManager instance] removeObserver:self forKeyPath:@"updating"];
	}
//
self.map = NULL;
//
[super dealloc];
}

- (CMap *)map
{
return map; 
}

- (void)setMap:(CMap *)inMap
{
if (map != inMap)
	{
	if (map != NULL)
		{
		[map removeObserver:self forKeyPath:@"levelOfDetailFloat"];
		
		[map autorelease];
		map = NULL;
		}
	
	if (inMap != NULL)
		{
		map = [inMap retain];

		[map addObserver:self forKeyPath:@"levelOfDetailFloat" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:kMapLevelOfDetailChanged];
		}
    }
}

- (CGFloat)accuracyRadius
{
return(accuracyRadius);
}

- (void)setAccuracyRadius:(CGFloat)inAccuracyRadius
{
if (accuracyRadius != inAccuracyRadius)
	{
	accuracyRadius = inAccuracyRadius;

	CGRect theFrame = self.frame;
	theFrame.size = CGSizeMake(accuracyRadius, accuracyRadius);
	self.frame = theFrame;
	}
}

- (void)drawInContext:(CGContextRef)inContext
{
CGContextSetStrokeColorWithColor(inContext, [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0].CGColor);

CGRect theBounds = self.bounds;
theBounds = CGRectInset(theBounds, 5.0, 5.0);
CGContextSetLineWidth(inContext, 2.5);
CGContextStrokeEllipseInRect(inContext, theBounds);

const CGFloat MINX = CGRectGetMinX(theBounds), MINY = CGRectGetMinY(theBounds);
const CGFloat MAXX = CGRectGetMaxX(theBounds), MAXY = CGRectGetMaxY(theBounds);
const CGFloat MIDX = CGRectGetMidX(theBounds), MIDY = CGRectGetMidY(theBounds);
const CGFloat W = 20.0;

const CGPoint thePoints[] = {
	{ .x = MINX, .y = MIDY }, { .x = MINX + W, .y = MIDY }, 
	{ .x = MAXX, .y = MIDY }, { .x = MAXX - W, .y = MIDY }, 
	{ .x = MIDX, .y = MINY }, { .x = MIDX, .y = MINY + W }, 
	{ .x = MIDX, .y = MAXY }, { .x = MIDX, .y = MAXY - W }, 
	};

CGContextStrokeLineSegments(inContext, thePoints, 8);
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
id theNew = [change objectForKey:@"new"];
if (theNew == [NSNull null])
	theNew = NULL;

if (context == kLocationChanged)
	{
	CLLocation *theLocation = theNew;
	if (theLocation != NULL)
		{
		self.opacity = 1.0;	
		self.coordinate = theLocation.coordinate;

		CGFloat theGroundResolution = [self.map groundResolutionForCoordinate:self.coordinate];

		CGFloat theRadius = theLocation.horizontalAccuracy / theGroundResolution;

		self.accuracyRadius = theRadius;
		[self.superlayer setNeedsLayout];
		}
	else
		{
		self.opacity = 0.0;	
		}
	}
else if (context == kLocationUpdating)
	{
	const BOOL theUpdatingFlag = [theNew boolValue];
	if (theUpdatingFlag == YES)
		{
		CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
		theAnimation.duration = 2.0;
		theAnimation.repeatCount = 1000;
		theAnimation.autoreverses = NO;
		theAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
		theAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DegreesToRadians(180.0), 0, 0, 1)];
		[self addAnimation:theAnimation forKey:@"spinner"];
		}
	else
		{
		self.transform = CATransform3DIdentity;
		[self removeAnimationForKey:@"spinner"];
		}
	}
else if (context == kMapLevelOfDetailChanged)
	{
	CLLocation *theLocation = [CBetterLocationManager instance].location;
	self.coordinate = theLocation.coordinate;

	CGFloat theGroundResolution = [self.map groundResolutionForCoordinate:self.coordinate];

	CGFloat theRadius = theLocation.horizontalAccuracy / theGroundResolution;

	self.accuracyRadius = theRadius;
	[self.superlayer setNeedsLayout];
	}
}


@end
