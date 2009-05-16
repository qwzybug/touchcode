//
//  UITableViewCell_ConvenienceExtensions.m
//  EverybodyVotes
//
//  Created by Jonathan Wight on 8/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "UITableViewCell_ConvenienceExtensions.h"

@implementation UITableViewCell (UITableViewCell_ConvenienceExtensions)

+ (UITableViewCell *)buttonCellWithReuseIdentifier:(NSString *)inReuseIdentifier title:(NSString *)inTitle color:(UIColor *)inColor target:(id)inTarget action:(SEL)inAction
{
UITableViewCell *theCell = [[[self alloc] initWithFrame:CGRectZero reuseIdentifier:inReuseIdentifier] autorelease];

UIImage *theImage = [[UIImage imageNamed:@"RedButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];

UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
theButton.frame = CGRectMake(0, 0, 320 - 10 - 10, 44);
theButton.font = [UIFont boldSystemFontOfSize:theButton.font.pointSize];
[theButton setTitle:inTitle forState:UIControlStateNormal];
//[theButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
[theButton setBackgroundImage:theImage forState:UIControlStateNormal];
[theButton addTarget:inTarget action:inAction forControlEvents:UIControlEventTouchUpInside];

[theCell.contentView addSubview:theButton];

theCell.backgroundView = [[[UIView alloc] initWithFrame:theButton.frame] autorelease];

return(theCell);
}


@end
