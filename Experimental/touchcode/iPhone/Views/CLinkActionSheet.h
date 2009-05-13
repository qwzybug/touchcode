//
//  CLinkActionSheet.h
//  TouchCode
//
//  Created by Jonathan Wight on 2/7/09.
//  Copyright 2009 TouchCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLinkActionSheet : UIActionSheet <UIActionSheetDelegate> {
	NSURL *URL;
}

@property (nonatomic, readwrite, retain) NSURL *URL;

- (id)initWithLink:(NSURL *)inURL;
- (id)initWithLink:(NSURL *)inURL defaultApplicationName:(NSString *)inDefaultApplicationName; // Designated constructor.

@end
