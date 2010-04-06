//
//  CBlankViewController.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CBlankViewController : UIViewController {
	UILabel *label;
}

@property (readwrite, nonatomic, retain) IBOutlet UILabel *label;

- (id)initWithText:(NSString *)inText;

@end
