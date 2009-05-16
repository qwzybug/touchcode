//
//  CMyTableViewCell.h
//  TouchCode
//
//  Created by Jonathan Wight on 03/26/08.
//  Copyright 2008 Toxic Software. All rights reserved.
//

#import <UIKit/UIKit.h>

/*** TODO JIW this needs a better name, but I'm lazy */
@interface CMyTableViewCell : UITableViewCell {
	UIView *content;
}

@property (readwrite, nonatomic, retain) UIView *content;

- (void)adjustLayout;

@end
