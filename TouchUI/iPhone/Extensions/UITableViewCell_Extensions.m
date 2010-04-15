//
//  UITableViewCell_Extensions.m
//  Small Society
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "UITableViewCell_Extensions.h"

@implementation UITableViewCell (UITableViewCell_Extensions)

+ (UITableViewCell *)cellWithPlaceholderText:(NSString *)inPlaceholderText reuseIdentifier:(NSString *)inReuseIdentifier
{
UITableViewCell *theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inReuseIdentifier] autorelease];
theCell.accessoryType = UITableViewCellAccessoryNone;
theCell.selectionStyle = UITableViewCellSelectionStyleNone;
theCell.textLabel.frame = CGRectMake(0, 0, 320, 44);
theCell.textLabel.textAlignment = UITextAlignmentCenter;
theCell.textLabel.textColor = [UIColor grayColor];
theCell.textLabel.text = inPlaceholderText;
return(theCell);
}

- (id)initWithReuseIdentifier:(NSString *)inReuseIdentifier
{
if ((self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inReuseIdentifier]) != NULL)
	{
	}
return(self);
}

- (void)setAccessoryImage:(UIImage *)inImage
{
UIImageView *theImageView = [[[UIImageView alloc] initWithImage:inImage] autorelease];
self.accessoryView = theImageView;
}

- (void)setAccessoryImageName:(NSString *)inString
{
[self setAccessoryImage:[UIImage imageNamed:inString]];
}

@end
