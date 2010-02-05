//
//  CMenu.h
//  Corkpad
//
//  Created by Jonathan Wight on 02/02/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMenuItem;

@interface CMenu : NSObject {
	CMenuItem *superItem;
	NSString *title;
	NSMutableArray *mutableItems;
	id userInfo;
}

@property (readwrite, nonatomic, assign) CMenuItem *superItem;
@property (readwrite, nonatomic, copy) NSString *title;
@property (readwrite, nonatomic, copy) NSArray *items;
@property (readwrite, nonatomic, retain) id userInfo;

- (void)addItem:(CMenuItem *)inItem;

@end
