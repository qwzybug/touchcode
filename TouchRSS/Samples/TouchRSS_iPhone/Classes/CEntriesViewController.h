//
//  CEntriesViewController.h
//  TouchCode
//
//  Created by Jonathan Wight on 9/12/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
