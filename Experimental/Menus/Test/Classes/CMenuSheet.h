//
//  CMenuSheet.h
//  Menus
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMenu;

@interface CMenuSheet : UIActionSheet <UIActionSheetDelegate> {
	CMenu *menu;
}

@property (readonly, nonatomic, retain) CMenu *menu;

- (id)initWithMenu:(CMenu *)inMenu;

@end
