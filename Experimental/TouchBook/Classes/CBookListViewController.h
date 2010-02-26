//
//  CBookListViewController.h
//  TouchBook
//
//  Created by Jonathan Wight on 02/25/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CMenuSplitViewController.h"

@class CBookLibrary;

@interface CBookListViewController : CMenuSplitViewController {
	CBookLibrary *library;
}

@property (readwrite, nonatomic, retain) CBookLibrary *library;


@end
