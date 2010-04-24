//
//  CPicker.h
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPickerDelegate;
@protocol CPickerController;

typedef enum {
	PickerType_Undefined,
	PickerType_Pushed,
	PickerType_Modal,
	PickerType_Popover,
	} EPickerType;

@interface CPicker : NSObject {
	EPickerType type;
	UINavigationController *navigationController;
	UIPopoverController *popoverController;
	UIViewController <CPickerController> *viewController;
	id initialValue;
	id value;
	NSString *validatorName;
	id <CPickerDelegate> delegate;
	id userInfo;
}

@property (readwrite, nonatomic, assign) EPickerType type;
@property (readwrite, nonatomic, retain) UINavigationController *navigationController;
@property (readwrite, nonatomic, retain) UIPopoverController *popoverController;
@property (readwrite, nonatomic, retain) UIViewController <CPickerController> *viewController;
@property (readwrite, nonatomic, retain) id initialValue;
@property (readwrite, nonatomic, retain) id value;
@property (readwrite, nonatomic, retain) NSString *validatorName;
@property (readwrite, nonatomic, assign) id <CPickerDelegate> delegate;
@property (readwrite, nonatomic, retain) id userInfo;

- (void)presentModal:(UIViewController *)inParentViewController fromBarButtonItem:(UIBarButtonItem *)inBarButtonItem animated:(BOOL)inAnimated;

- (void)done:(id)inSender;
- (void)cancel:(id)inSender;

@end

#pragma mark -

@protocol CPickerController <NSObject>
@required
@property (readwrite, nonatomic, retain) CPicker *picker;

@optional
- (id)initWithPicker:(CPicker *)inPicker;
@end

#pragma mark -

@protocol CPickerDelegate <NSObject>

@optional

- (void)picker:(CPicker *)inPicker didFinishWithValue:(id)inValue;
- (void)pickerDidCancel:(CPicker *)inPicker;
- (void)picker:(CPicker *)inPicker valueDidChange:(id)inValue;

@end
