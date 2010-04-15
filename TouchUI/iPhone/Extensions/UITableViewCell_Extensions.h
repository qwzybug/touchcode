//
//  UITableViewCell_Extensions.h
//  Small Society
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (UITableViewCell_Extension)

+ (UITableViewCell *)cellWithPlaceholderText:(NSString *)inPlaceholderText reuseIdentifier:(NSString *)inReuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)inReuseIdentifier;

- (void)setAccessoryImage:(UIImage *)inImage;
- (void)setAccessoryImageName:(NSString *)inString;

@end
