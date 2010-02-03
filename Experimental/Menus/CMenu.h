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
	NSMutableArray *mutableItems;
	id userInfo;
}

@property (readonly, nonatomic, retain) NSArray *items;
@property (readonly, nonatomic, retain) id userInfo;

- (void)addItem:(CMenuItem *)inItem;

@end
