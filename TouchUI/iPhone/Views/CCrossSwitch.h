//
//  CCrossSwitch.h
//  TouchWar
//
//  Created by Jonathan Wight on 04/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCrossSwitch : UIControl {
	BOOL on;
	CALayer *imageLayer;
}

@property(nonatomic,getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end
