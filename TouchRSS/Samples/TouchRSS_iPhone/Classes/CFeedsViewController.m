//
//  CFeedsViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 11/21/08.
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
CFeed *theFeed = [[CDemoFeedStore instance] feedforURL:[NSURL URLWithString:@"http://toxicsoftware.com/feed/"]];
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

