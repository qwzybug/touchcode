//
//  CBetterAlertView.h
//  TouchCode
//
//  Created by Jonathan Wight on 9/16/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBetterAlertView : UIAlertView {
	id userInfo;
}

@property (readwrite, nonatomic, retain) id userInfo;

@end
