//
//  CDetailViewController.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHostingView;

@interface CDetailViewController : UIViewController {
	UINavigationBar *navigationBar;
	CHostingView *hostingView;
}

@property (readwrite, nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (readwrite, nonatomic, retain) IBOutlet CHostingView *hostingView;
@property (readwrite, nonatomic, retain) UIViewController *viewController;

@end
