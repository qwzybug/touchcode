//
//  CEntriesViewController.h
//  ProjectV
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCompletionTicket.h"

@class CProgressOverlayView;
@class CFeedStore;
@class CFeed;

@protocol CEntriesDetailViewController;

#pragma mark -

@interface CEntriesViewController : UITableViewController <CCompletionTicketDelegate> {
	CFeedStore *feedStore;
	NSArray *entries;
	NSArray *feeds;
	CCompletionTicket *completionTicket;

	CProgressOverlayView *progressOverlayView;
}

@property (readwrite, nonatomic, retain) CFeedStore *feedStore;
@property (readwrite, nonatomic, retain) NSArray *entries;
@property (readwrite, nonatomic, retain) NSArray *feeds;
@property (readwrite, nonatomic, retain) CFeed *feed;

@property (readwrite, nonatomic, retain) NSArray *feedURLs;
@property (readwrite, nonatomic, retain) NSURL *feedURL;

@property (readwrite, nonatomic, retain) CProgressOverlayView *progressOverlayView;

- (void)updateEntries;
- (NSArray *)entriesForFeeds:(NSArray *)inFeeds;

- (void)showProgressScreen:(NSString *)inLabel;
- (void)hideProgressScreen;

- (UIViewController <CEntriesDetailViewController> *)detailViewControllerWithEntries:(NSArray *)inEntries currentEntryIndex:(NSInteger )inCurrentEntryIndex;

@end

#pragma mark -

@protocol CEntriesDetailViewController <NSObject>

@property (readwrite, nonatomic, retain) NSArray *entries;
@property (readwrite, nonatomic, assign) NSInteger currentEntryIndex;

@end
