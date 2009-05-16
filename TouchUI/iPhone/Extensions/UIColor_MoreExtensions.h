//
//  UIColor_MoreExtensions.h
//  PettySVG
//
//  Created by Jonathan Wight on 08/13/2005.
//  Copyright (c) 2005 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @category UIColor (UIColor_MoreExtensions)
 * @abstract TODO
 * @discussion TODO
 */
@interface UIColor (UIColor_MoreExtensions)

+ (id)colorWithSVGString:(NSString *)inString;
+ (id)colorWithHTMLString:(NSString *)inHTMLString;

@end
