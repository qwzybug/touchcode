//
//  CDistancePickerController.h
//  touchcode
//
//  Created by Jonathan Wight on 05/07/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPickerController.h"

@interface CValuesPickerController : UITableViewController <CPickerController> {
	NSInteger selectedValueIndex;
	NSArray *values;
	NSString *textLabelKeyPath;
	NSValueTransformer *textLabelTransformer;
	NSString *imageViewKeyPath;
	id initialValue;
	id value;
	NSString *validator;
	id <CPickerControllerDelegate> pickerDelegate;
	id userInfo;
}

@property (readwrite, nonatomic, assign) NSInteger selectedValueIndex;
@property (readwrite, nonatomic, retain) NSArray *values;
@property (readwrite, nonatomic, retain) NSString *textLabelKeyPath;
@property (readwrite, nonatomic, retain) NSValueTransformer *textLabelTransformer;
@property (readwrite, nonatomic, retain) NSString *imageViewKeyPath;

@end
