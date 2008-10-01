//
//  UITableViewCell_ConvenienceExtensions.h
//  EverybodyVotes
//
//  Created by Jonathan Wight on 8/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (UITableViewCell_ConvenienceExtensions)

+ (UITableViewCell *)buttonCellWithReuseIdentifier:(NSString *)inReuseIdentifier title:(NSString *)inTitle color:(UIColor *)inColor target:(id)inTarget action:(SEL)inAction;

@end
