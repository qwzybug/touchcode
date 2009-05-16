//
//  CFeedsViewController.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 11/21/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CFeedsViewController.h"

#import "CFeed.h"
#import "CDemoFeedStore.h"
#import "CEntriesViewController.h"
#import "CFeedFetcher.h"

@implementation CFeedsViewController

- (void)viewDidLoad
{
[super viewDidLoad];
//
//CFeed *theFeed = [[CDemoFeedStore instance] feedforURL:[NSURL URLWithString:@"http://toxicsoftware.com/feed/"]];
CFeed *theFeed = [[CDemoFeedStore instance] feedforURL:[NSURL URLWithString:@"file://localhost/Users/schwa/Downloads/iphone_feed.xml"]];
[[CDemoFeedStore instance].feedFetcher updateFeed:theFeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
return([CDemoFeedStore instance].feeds.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *theCellIdentifier = @"Cell";

CFeed *theFeed = [[CDemoFeedStore instance].feeds objectAtIndex:indexPath.row];
    
UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:theCellIdentifier];
if (theCell == nil)
	{
	theCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:theCellIdentifier] autorelease];
	theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

if (theFeed.title)
	theCell.text = theFeed.title;
else
	theCell.text = [theFeed.url absoluteString];

return(theCell);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
CFeed *theFeed = [[CDemoFeedStore instance].feeds objectAtIndex:indexPath.row];

CEntriesViewController *theController = [[[CEntriesViewController alloc] initWithNibName:NULL bundle:NULL] autorelease];
theController.feedStore = [CDemoFeedStore instance];
theController.feed = theFeed;
[self.navigationController pushViewController:theController animated:YES];
}

@end

