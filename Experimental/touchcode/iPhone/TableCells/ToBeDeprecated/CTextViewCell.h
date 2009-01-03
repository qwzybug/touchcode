//
//  CTextViewCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 12/2/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTextViewCell : UITableViewCell <UITextViewDelegate> {
	IBOutlet UITextView *outletTextView;
}

@property (readwrite, nonatomic, retain) UITextView *textView;

+ (CTextViewCell *)cell;

@end
