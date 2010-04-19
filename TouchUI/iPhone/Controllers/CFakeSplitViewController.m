    //
//  CFakeSplitViewController.m
//  DNC
//
//  Created by Jonathan Wight on 04/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CFakeSplitViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation CFakeSplitViewController

@synthesize masterViewController;
@synthesize detailViewController;

- (void)dealloc
{
[masterViewController release];
masterViewController = NULL;
[detailViewController release];
detailViewController = NULL;
//
[super dealloc];
}

- (void)loadView
{
UIView *theDrawingView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

CALayer *theLayer = [CALayer layer];
theLayer.frame = theDrawingView.bounds;
theLayer.delegate = self;
[theLayer setNeedsDisplay];
[theDrawingView.layer addSublayer:theLayer];

theDrawingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

self.view = theDrawingView;
}

- (void)viewDidUnload
{
[super viewDidUnload];
//
[masterViewController release];
masterViewController = NULL;
[detailViewController release];
detailViewController = NULL;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(YES);
}

#pragma mark -

- (void)setMasterViewController:(UIViewController *)inMasterViewController
{
if (masterViewController != inMasterViewController)
	{
	if (masterViewController != NULL)
		{
		[masterViewController viewWillDisappear:NO];
		[masterViewController.view removeFromSuperview];
		[masterViewController viewDidDisappear:NO];
		
		[masterViewController release];
		masterViewController = NULL;
		}
		
	if (inMasterViewController != NULL)
		{
		masterViewController = [inMasterViewController retain];
		
		[masterViewController viewWillAppear:NO];

		UIView *theMasterView = self.masterViewController.view;
		theMasterView.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height);
		theMasterView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		
		[self.view addSubview:theMasterView];

		[masterViewController viewDidAppear:NO];
		}
	}
}

- (void)setDetailViewController:(UIViewController *)inDetailViewController
{
if (detailViewController != inDetailViewController)
	{
	if (detailViewController != NULL)
		{
		[detailViewController viewWillDisappear:NO];
		[detailViewController.view removeFromSuperview];
		[detailViewController viewDidDisappear:NO];
		
		[detailViewController release];
		detailViewController = NULL;
		}
		
	if (inDetailViewController != NULL)
		{
		detailViewController = [inDetailViewController retain];
		
		[detailViewController viewWillAppear:NO];

		UIView *theDetailView = self.detailViewController.view;
		theDetailView.frame = CGRectMake(321.0, 0.0, self.view.bounds.size.width - 321.0, self.view.bounds.size.height);
		theDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:theDetailView];

		[detailViewController viewDidAppear:NO];
		}
	}
}

#pragma mark -

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
CGContextMoveToPoint(ctx, 320, 0);
CGContextAddLineToPoint(ctx, 320, 10000);
CGContextStrokePath(ctx);
}

@end
