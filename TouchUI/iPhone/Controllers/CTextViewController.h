//
//  CTextViewController.h
//  Touchcode
//
//  Created by Jonathan Wight on 8/18/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPicker.h"

@interface CTextViewController : UIViewController <UITextViewDelegate, CPickerController> {
	UITextView *textView;
	CPicker *picker;
}

@property (readwrite, nonatomic, retain) IBOutlet UITextView *textView;

- (id)init;

@end
