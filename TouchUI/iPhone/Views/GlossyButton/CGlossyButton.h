//
//  CGlossyButton.h
//  Birdfeed Redux
//
//  Created by Jonathan Wight on 03/30/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGlossyButton : UIButton {

}

+ (CGlossyButton *)buttonWithTitle:(NSString *)inTitle target:(id)inTarget action:(SEL)inAction;

@end
