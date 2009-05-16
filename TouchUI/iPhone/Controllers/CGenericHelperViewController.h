//
//  CGenericHelperViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/28/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CGenericHelperViewControllerDelegate;

@interface CGenericHelperViewController : UIViewController {
	id <CGenericHelperViewControllerDelegate> delegate;
	NSString *identifier;
	id representedObject;
	id value;
	UIBarButtonItem *cancelButton;
	UIBarButtonItem *okButton;
}

@property (readwrite, nonatomic, assign) id <CGenericHelperViewControllerDelegate> delegate;
@property (readwrite, nonatomic, retain) NSString *identifier;
@property (readwrite, nonatomic, retain) id representedObject;
@property (readwrite, nonatomic, retain) id value;
@property (readwrite, nonatomic, retain) UIBarButtonItem *cancelButton;
@property (readwrite, nonatomic, retain) UIBarButtonItem *okButton;

- (void)actionCancel:(id)inSender;
- (void)actionDone:(id)inSender;

@end

#pragma mark -

@protocol CGenericHelperViewControllerDelegate

@optional

- (void)viewControllerDidFinish:(CGenericHelperViewController *)inController;
- (void)viewControllerDidCancel:(CGenericHelperViewController *)inController;

@end