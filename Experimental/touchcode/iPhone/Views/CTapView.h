//
//  CTapView.h
//  TouchCode
//
//  Created by Jonathan Wight on 07/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTapView : UIImageView {
	id target;
	SEL action;
	
}

@property (readwrite, nonatomic, assign) id target;
@property (readwrite, nonatomic, assign) SEL action;

@end
