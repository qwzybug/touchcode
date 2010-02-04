//
//  CBubbleView.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/12/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLayoutView;

@interface CBubbleView : UIControl {
	UILabel *titleLabel;
	UILabel *messageLabel;
	NSArray *accessoryViews;
	//
	CLayoutView *layoutView;
}

@property (readonly, nonatomic, retain) UILabel *titleLabel;
@property (readonly, nonatomic, retain) UILabel *messageLabel;
@property (readwrite, nonatomic, retain) NSArray *accessoryViews;

- (id)init;

@end
