//
//  CLoggingMessageDetailViewController.h
//  Touchcode
//
//  Created by Jonathan Wight on 05/11/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface CLoggingMessageDetailViewController : UITableViewController {
	NSManagedObject *message;
	NSDictionary *extraAttributes;
}

@property (readwrite, nonatomic, retain) NSManagedObject *message;
@property (readwrite, nonatomic, retain) NSDictionary *extraAttributes;

@end
