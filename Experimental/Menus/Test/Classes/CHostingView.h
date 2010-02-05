//
//  CHostingView.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHostingView : UIView {
	UIViewController *viewController;
}

@property (readwrite, nonatomic, retain) UIViewController *viewController;

@end
