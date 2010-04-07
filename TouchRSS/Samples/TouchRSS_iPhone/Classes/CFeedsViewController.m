//
//  CFeedsViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/4/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import "CFeedStore.h"
#import "CFeed.h"
#import "CFeedFetcher.h"
#import "CFeedEntriesViewController.h"

@implementation CFeedsViewController

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.title = @"Feeds";
self.navigationItem.rightBarButtonItem = [self addButtonItem];

UILabel *thePlaceholderLabel = (UILabel *)self.placeholderView;
thePlaceholderLabel.text = @"No feeds";

NSEntityDescription *theEntityDescription = [NSEntityDescription entityForName:[CFeed entityName] inManagedObjectContext:[CFeedStore instance].managedObjectContext];
NSAssert(theEntityDescription != NULL, @"No entity description.");
NSFetchRequest *theFetchRequest = [[[NSFetchRequest alloc] init] autorelease];
[theFetchRequest setEntity:theEntityDescription];

NSArray *theSortDescriptors = [NSArray arrayWithObjects:
	[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES] autorelease],
	NULL];
theFetchRequest.sortDescriptors = theSortDescriptors;

self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:theFetchRequest managedObjectContext:[CFeedStore instance].managedObjectContext sectionNameKeyPath:NULL cacheName:NULL] autorelease];
self.fetchedResultsController.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//return(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : toInterfaceOrientation == UIDeviceOrientationPortrait);
return(YES);
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *theCellIdentifier = @"Cell";

UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:theCellIdentifier];
if (theCell == NULL)
	{
	theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:theCellIdentifier] autorelease];
	theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

CFeed *theFeed = [self.fetchedResultsController objectAtIndexPath:indexPath];

theCell.textLabel.text = theFeed.title;

return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
CFeed *theFeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
CFeedEntriesViewController *theViewController = [[[CFeedEntriesViewController alloc] initWithFeedStore:[CFeedStore instance] feed:theFeed] autorelease];
[self.navigationController pushViewController:theViewController animated:YES];

}

#pragma mark -

- (IBAction)add:(id)inSender
{
NSURL *theURL = [NSURL URLWithString:@"http://toxicsoftware.com/feed/"];
NSError *theError = NULL;
[[CFeedStore instance].feedFetcher subscribeToURL:theURL error:&theError];
}

@end

