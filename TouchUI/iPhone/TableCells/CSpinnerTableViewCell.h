//
//  CSpinnerTableViewCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 08/18/09.
//  Copyright 2009 toxicsoftware.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSpinnerTableViewCell : UITableViewCell {
	UIActivityIndicatorView *activityIndictor;
}

@property (readwrite, nonatomic, assign) BOOL spinning;
@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndictor;

@end
