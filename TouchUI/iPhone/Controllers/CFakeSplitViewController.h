//
//  CFakeSplitViewController.h
//  DNC
//
//  Created by Jonathan Wight on 04/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFakeSplitViewController : UIViewController {
	UIViewController *masterViewController;
	UIViewController *detailViewController;
}

@property (readwrite, nonatomic, retain) UIViewController *masterViewController;
@property (readwrite, nonatomic, retain) UIViewController *detailViewController;

@end
