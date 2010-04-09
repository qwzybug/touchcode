//
//  CDateRangePickerController.h
//  touchcode
//
//  Created by Jonathan Wight on 05/07/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPickerController.h"

@interface CDateRangePickerController : UIViewController <CPickerController, UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *outletTableView;
	IBOutlet UIDatePicker *outletDatePicker;
	IBOutlet UIPickerView *outletDurationPicker;
	
	id initialValue;
	NSString *validator;
	id <CPickerControllerDelegate> pickerDelegate;
	id userInfo;

	NSDate *starts;
	NSDate *ends;
	NSTimeInterval minimumDuration;
}

@property (readwrite, nonatomic, retain) NSDate *starts;
@property (readwrite, nonatomic, retain) NSDate *ends;
@property (readwrite, nonatomic, assign) NSTimeInterval minimumDuration;

- (void)reset;

- (IBAction)actionDateChanged:(id)inSender;

@end
