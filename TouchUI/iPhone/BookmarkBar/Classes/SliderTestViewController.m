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
#import "UIImage_Extensions.h"

@implementation SliderTestViewController

- (void)viewDidLoad
{
[super viewDidLoad];
//
CBookmarkBar *theBookmarkBar = [[[CBookmarkBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
theBookmarkBar.backgroundColor = [UIColor grayColor];

NSMutableDictionary *theAttributes = [[theBookmarkBar.defaultItemAttributes mutableCopy] autorelease];
UIImage *theUnselectedImage = [UIImage imageWithBackgroundImage:[[UIImage imageNamed:@"BookmarkButtonBackground_A.png"] imageTintedWithColor:theBookmarkBar.backgroundColor] foregroundImage:[UIImage imageNamed:@"BookmarkButtonBorder_A.png"]];
theUnselectedImage = [theUnselectedImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
[theAttributes setObject:theUnselectedImage forKey:@"image"];
theBookmarkBar.defaultItemAttributes = theAttributes;

// 
theAttributes = [[theBookmarkBar.selectedItemAttributes mutableCopy] autorelease];
UIImage *theSelectedImage = [UIImage imageWithBackgroundImage:[[UIImage imageNamed:@"BookmarkButtonBackground_B.png"] imageTintedWithColor:self.view.backgroundColor] foregroundImage:[UIImage imageNamed:@"BookmarkButtonBorder_B.png"]];
theSelectedImage = [theSelectedImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
[theAttributes setObject:theSelectedImage forKey:@"image"];
theBookmarkBar.selectedItemAttributes = theAttributes;

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

[self.view addSubview:theBookmarkBar];

}

@end
