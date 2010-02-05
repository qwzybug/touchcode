//
//  CBadgeView.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLayoutView;

@interface CBadgeView : UIButton {
	UIImageView *imageView;
	UILabel *titleLabel;
	UIView *accessoryView;
	//
	CLayoutView *layoutView;
}

@property (readonly, nonatomic, retain) UIImageView *imageView;
@property (readonly, nonatomic, retain) UILabel *titleLabel;
@property (readwrite, nonatomic, retain) UIView *accessoryView;

@end
