//
//  UIViewController_Extensions.h
//  touchcode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController_Extensions)

@property (readonly, nonatomic, assign) BOOL isModal;

- (void)dismissAnimated:(BOOL)inAnimated;

@end
