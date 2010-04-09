//
//  CPickerTableViewController.h
//  touchcode
//
//  Created by Jonathan Wight on 5/22/09.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTableViewController.h"

#import "CPicker.h"

@interface CPickerTableViewController : CTableViewController <CPickerController> {
	CPicker *picker;
	UIBarButtonItem *finishButtonItem;	
	UIBarButtonItem *cancelButtonItem;
	}

@property (readonly, nonatomic, retain) UIBarButtonItem *finishButtonItem;
@property (readonly, nonatomic, retain) UIBarButtonItem *cancelButtonItem;

- (IBAction)done:(id)inSender;
- (IBAction)cancel:(id)inSender;

@end
