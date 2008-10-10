//
//  CEntryWebViewController.h
//  Obama 08
//
//  Created by Jonathan Wight on 9/15/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CWebViewController.h"

#import "CEntriesViewController.h"

@class CFeedEntry;
@class CTrivialTemplate;

@interface CEntryWebViewController : CWebViewController <CEntriesDetailViewController> {
	NSArray *entries;
	NSInteger currentEntryIndex;

	CTrivialTemplate *template;

	IBOutlet UISegmentedControl *outletNextPreviousEntrySegmentedControl;
}

@property (readwrite, nonatomic, retain) NSArray *entries;
@property (readwrite, nonatomic, assign) NSInteger currentEntryIndex;
@property (readwrite, nonatomic, retain) CTrivialTemplate *template;
@property (readwrite, nonatomic, retain) UISegmentedControl *nextPreviousEntrySegmentedControl;

- (void)loadHTMLForEntry:(CFeedEntry *)inEntry;

- (void)updateUI;

@end
