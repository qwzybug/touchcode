//
//  TestViewController.h
//  Test
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBonjourBrowserViewController : UITableViewController {
	NSString *type;
	NSString *domain;
	NSNetServiceBrowser *browser;
	NSMutableArray *services;
}

@property (readwrite, nonatomic, retain) NSString *type;
@property (readwrite, nonatomic, retain) NSString *domain;
@property (readwrite, nonatomic, retain) NSNetServiceBrowser *browser;

@property (readwrite, nonatomic, retain) NSMutableArray *services;


@end

