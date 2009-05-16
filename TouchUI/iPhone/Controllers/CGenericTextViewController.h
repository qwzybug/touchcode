//
//  CGenericTextViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import "CGenericHelperViewController.h"

@interface CGenericTextViewController : CGenericHelperViewController <UITextViewDelegate> {
	UITextView *textView;
}

@property (readonly, nonatomic, retain) UITextView *textView;

@end
