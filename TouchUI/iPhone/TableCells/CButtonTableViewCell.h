//
//  CButtonTableViewCell.h
//  touchcode
//
//  Created by Jonathan Wight on 5/8/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGlossyButton;

@interface CButtonTableViewCell : UITableViewCell {
	UIButton *button;
	id target;
	SEL action;
}

@property (readwrite, nonatomic, retain) UIButton *button;
@property (readwrite, nonatomic, assign) id target;
@property (readwrite, nonatomic, assign) SEL action;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
