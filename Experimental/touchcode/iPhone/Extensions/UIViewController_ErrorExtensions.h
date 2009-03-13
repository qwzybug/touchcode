//
//  UIViewController_ErrorExtensions.h
//  TouchCode
//
//  Created by Jonathan Wight on 3/2/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewController_ErrorExtensions)

- (void)presentError:(NSError *)inError;

@end
