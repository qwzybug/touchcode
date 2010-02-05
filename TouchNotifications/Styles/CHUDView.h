//
//  CHUDView.h
//  UserNotificationManager
//
//  Created by Jonathan Wight on 10/13/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHUDView : UIView {
	CGFloat borderWidth;
}

@property (readwrite, nonatomic, assign) CGFloat borderWidth;
@property (readwrite, nonatomic, retain) UIView *contentView;

@end
