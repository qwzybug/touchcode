//
//  SliderTestViewController.m
//  SliderTest
//
//  Created by Jonathan Wight on 01/05/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import "SliderTestViewController.h"

#import "CBookmarkBar.h"
#import "CBookmarkBarItem.h"

@implementation SliderTestViewController

- (void)viewDidLoad
{
[super viewDidLoad];
//
CBookmarkBar *theBookmarkBar = [[[CBookmarkBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
[self.view addSubview:theBookmarkBar];


CBookmarkBarItem *theItem1 = [[[CBookmarkBarItem alloc] init] autorelease];
theItem1.title = @"Hello World";

CBookmarkBarItem *theItem2 = [[[CBookmarkBarItem alloc] init] autorelease];
theItem2.title = @"This is Item 2";

CBookmarkBarItem *theItem3 = [[[CBookmarkBarItem alloc] init] autorelease];
theItem3.title = @"Item 3";

CBookmarkBarItem *theItem4 = [[[CBookmarkBarItem alloc] init] autorelease];
theItem4.title = @"This is Item 4";


NSArray *theArray = [NSArray arrayWithObjects:theItem1, theItem2, theItem3, theItem4, NULL];

theBookmarkBar.items = theArray;


NSLog(@"%@", self.view.subviews);
}

@end
