//
//  RootViewController.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/4/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
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
self.placeholderLabel.text = @"No feeds";

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

[self update];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
return(self.fetchedResultsController.sections.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
return([[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects]);
}

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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
[self update];
}

#pragma mark -

- (IBAction)addFeed:(id)inSender
{
NSURL *theURL = [NSURL URLWithString:@"http://toxicsoftware.com/feed/"];
NSError *theError = NULL;
[[CFeedStore instance].feedFetcher subscribeToURL:theURL error:&theError];
}

@end

