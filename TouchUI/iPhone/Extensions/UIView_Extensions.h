//
//  UIView_Extensions.h
//  PlateView
//
//  Created by Jonathan Wight on 1/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (UIView_Extensions)

- (void)setClipsToBoundsRecursively:(BOOL)clips;

- (void)dump:(NSInteger)inDepth;

@end
