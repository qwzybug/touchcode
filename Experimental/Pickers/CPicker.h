//
//  CPicker.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/09/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
