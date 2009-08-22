//
//  CTextViewController.h
//  Touchcode
//
//  Created by Jonathan Wight on 8/18/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTextViewController : UIViewController <UITextViewDelegate> {
	IBOutlet UITextView *textView;
	NSString *initialText;
}

@property (readwrite, nonatomic, retain) UITextView *textView;

- (id)initWithText:(NSString *)inText;

@end
