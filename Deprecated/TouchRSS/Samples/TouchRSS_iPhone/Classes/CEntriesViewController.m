//
//  CEntriesViewController.m
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

#import "CEntriesViewController.h"

#import "CFeed.h"
#import "CFeedEntry.h"
#import "CEntryTableViewCell.h"
#import "CHumanDateFormatter.h"
#import "CFeedStore.h"
#import "CEntryWebViewController.h"
#import "CLazyCache.h"
#import "CProgressOverlayView.h"
#import "CTrivialTemplate.h"
#import "CFeedFetcher.h"

static CLazyCache *gTimestampCache = NULL;

@interface CEntriesViewController ()
@property (readwrite, nonatomic, retain) CCompletionTicket *completionTicket;
@end

#pragma mark -

@implementation CEntriesViewController

@synthesize feedStore;
@synthesize entries;
@dynamic feeds;
@dynamic feed;
@dynamic feedURLs;
@dynamic feedURL;
@synthesize progressOverlayView;
@synthesize completionTicket;

- (void)dealloc
{
[self.feedStore.feedFetcher cancel];
self.feedStore = NULL;

[self.completionTicket invalidate];
self.completionTicket = NULL;

self.entries = NULL;
self.feeds = NULL;

self.tableView = NULL;
self.view = NULL;
//
[super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
[super viewWillDisappear:animated];
//
[self hideProgressScreen];
}

#pragma mark -

- (NSArray *)feeds
{
return(feeds); 
}

- (void)setFeeds:(NSArray *)inFeeds
{
if (feeds != inFeeds)
	{
	[feeds autorelease];
	feeds = [inFeeds retain];
		
	[self updateEntries];
    }
}

- (CFeed *)feed
{
if (self.feeds == NULL)
	return(NULL);
else
	{
	NSAssert(self.feeds.count == 1, @"Should not call feed when there is not 1 feed");
	return([self.feeds lastObject]); 
	}
}

- (void)setFeed:(CFeed *)inFeed
{
if (inFeed == NULL)
	self.feeds = NULL;
else
	self.feeds = [NSArray arrayWithObject:inFeed];
	
[self updateEntries];
}

- (NSArray *)feedURLs
{
return([self.feeds valueForKey:@"url"]);
}

- (void)setFeedURLs:(NSArray *)inFeedURLs
{
NSLog(@"Fetching URLS: %@", inFeedURLs);

NSMutableArray *theFeeds = [NSMutableArray arrayWithCapacity:inFeedURLs.count];
for (NSURL *theURL in inFeedURLs)
	{
	CFeed *theFeed = [self.feedStore feedforURL:theURL];
	if (theFeed == NULL)
		{
		NSError *theError = NULL;
		theFeed = [self.feedStore.feedFetcher subscribeToURL:theURL error:&theError];
		}
	[theFeeds addObject:theFeed];

	[self updateEntries];

	self.completionTicket = [CCompletionTicket completionTicketWithIdentifier:@"Load Feeds" delegate:self userInfo:NULL];
	[self.feedStore.feedFetcher updateFeed:theFeed completionTicket:self.completionTicket];

	}

self.feeds = theFeeds;
}

- (NSURL *)feedURL
{
return(self.feed.url); 
}

- (void)setFeedURL:(NSURL *)inFeedURL
{
CFeed *theFeed = [self.feedStore feedforURL:inFeedURL];
if (theFeed == NULL)
	{
	NSError *theError = NULL;
	theFeed = [self.feedStore.feedFetcher subscribeToURL:inFeedURL error:&theError];
	}

self.feed = theFeed;

[self updateEntries];
		
CCompletionTicket *theCompletionTicket = [CCompletionTicket completionTicketWithIdentifier:@"SetFeedURL" delegate:self userInfo:NULL];
[self.feedStore.feedFetcher updateFeed:theFeed completionTicket:theCompletionTicket];
}

#pragma mark -

- (UIViewController <CEntriesDetailViewController> *)detailViewControllerWithEntries:(NSArray *)inEntries currentEntryIndex:(NSInteger )inCurrentEntryIndex
{
CEntryWebViewController *theWebViewController = [CEntryWebViewController webViewController];
theWebViewController.template = [[[CTrivialTemplate alloc] initWithTemplateName:@"template_news.html"] autorelease];
theWebViewController.entries = inEntries;
theWebViewController.currentEntryIndex = inCurrentEntryIndex;
return(theWebViewController);
}

#pragma mark -

- (void)updateEntries
{
if (self.feeds == NULL || self.feeds.count == 0)
	self.entries = NULL;
else
	{
	self.entries = [self entriesForFeeds:self.feeds];
	}
//
[self.tableView reloadData];
}

- (NSArray *)entriesForFeeds:(NSArray *)inFeeds
{
NSArray *theEntries = [self.feedStore entriesForFeeds:inFeeds];
return(theEntries);
}

- (void)showProgressScreen:(NSString *)inLabel
{
if (self.progressOverlayView == NULL)
	{
	self.progressOverlayView = [[[CProgressOverlayView alloc] initWithLabel:inLabel] autorelease];
	self.progressOverlayView.backgroundColor = [UIColor clearColor];
	self.progressOverlayView.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	self.progressOverlayView.mode = ProgressOverlayViewMode_Indeterminate;
	[self.progressOverlayView showWithDelay:0.5];
	}
}

- (void)hideProgressScreen
{
if (self.progressOverlayView)
	{
	[self.progressOverlayView hide];
	self.progressOverlayView = NULL;
	}
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
NSLog(@"ENTRIES: %d", self.entries.count);
return(self.entries.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
CEntryTableViewCell *theCell = (CEntryTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"EntryTableCell"];
if (theCell == NULL)
	{
	theCell = [CEntryTableViewCell cell];
	NSAssert([theCell.reuseIdentifier isEqualToString:@"EntryTableCell"], @"Reuse identifiers do not match.");
	}
	
CFeedEntry *theEntry = [self.entries objectAtIndex:indexPath.row];
theCell.text = theEntry.title;

// #############################################################################
if (gTimestampCache == NULL)
	gTimestampCache = [[CLazyCache alloc] initWithCapacity:100]; // TODO -- yes we leak here, what are you going to do about it?
	
NSDate *theDate = theEntry.updated;
NSString *theDateString = [gTimestampCache cachedObjectForKey:theDate];
if (theDateString == NULL)
	{
	theDateString = [[CHumanDateFormatter humanDateFormatter:NO] stringFromDate:theEntry.updated];
	[gTimestampCache cacheObject:theDateString forKey:theDate];
	}

theCell.timestampLabel.text = theDateString;
	
// #############################################################################

return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
UIViewController <CEntriesDetailViewController> *theViewController = [self detailViewControllerWithEntries:self.entries currentEntryIndex:indexPath.row];
[self.navigationController pushViewController:theViewController animated:YES];
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didBeginForTarget:(id)inTarget;
{
if (self.entries.count == 0)
	{
	[self showProgressScreen:@"Loading..."];
	}
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
NSLog(@"RSS feed(s) received.");

[self hideProgressScreen];

[self updateEntries];

if ([self tableView:self.tableView numberOfRowsInSection:0] > 0)
	{
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError
{
[self hideProgressScreen];

UIAlertView *theAlert = [[[UIAlertView alloc] initWithTitle:NULL message:@"Could not connect to the Internet. Please try again later." delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL] autorelease];
[theAlert show];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget
{
[self hideProgressScreen];
}

@end

