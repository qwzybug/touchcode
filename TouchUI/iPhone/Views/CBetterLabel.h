//
//  CBetterLabel.h
//  Starbucks
//
//  Created by brandon on 7/13/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	UITextVerticalAlignmentCenter,
	UITextVerticalAlignmentTop,
	UITextVerticalAlignmentBottom
} UITextVerticalAlignment;

@interface CBetterLabel : UILabel
{
	UITextVerticalAlignment verticalAlignment;
	BOOL variableHeightText;
}

@property (assign, nonatomic) UITextVerticalAlignment verticalAlignment;
@property (assign, nonatomic) BOOL variableHeightText;

@end
