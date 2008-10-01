//
//  MapToyAppDelegate.m
//  MapToy
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "CMapToyViewController.h"

#import "CMap.h"
#import "CMapView.h"

@implementation CMapToyViewController

@dynamic scrollView;

- (void)loadView
{
[super loadView];
/*
self.scrollView.showsVerticalScrollIndicator = NO;
self.scrollView.showsHorizontalScrollIndicator = NO;
self.scrollView.contentSize = CGSizeMake(1000,1000);
*/

CMap *theMap = [[[CMap alloc] init] autorelease];
outletMapView.map = theMap;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return(YES);
}

- (UIScrollView *)scrollView
{
return((UIScrollView *)self.view);
}

@end
