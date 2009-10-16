//
//  CFeedEntriesViewController.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 10/4/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
//

#import "CFeedEntriesViewController.h"

#import "CFeedStore.h"
#import "CFeedEntry.h"
#import "CFeed.h"

@implementation CFeedEntriesViewController

@synthesize feed;

- (id)initWithFeed:(CFeed *)inFeed;
{
if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.feed = inFeed;
	self.title = inFeed.title;
	}
return(self);
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.placeholderLabel.text = @"No entries";

NSEntityDescription *theEntityDescription = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:[CFeedStore instance].managedObjectContext];
NSAssert(theEntityDescription != NULL, @"No entity description.");
NSFetchRequest *theFetchRequest = [[[NSFetchRequest alloc] init] autorelease];
[theFetchRequest setEntity:theEntityDescription];

NSArray *theSortDescriptors = [NSArray arrayWithObjects:
	[[[NSSortDescriptor alloc] initWithKey:@"updated" ascending:NO] autorelease],
	NULL];
theFetchRequest.sortDescriptors = theSortDescriptors;

self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:theFetchRequest managedObjectContext:[CFeedStore instance].managedObjectContext sectionNameKeyPath:NULL cacheName:NULL] autorelease];
self.fetchedResultsController.delegate = self;

[self update];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
NSUInteger theCount = self.fetchedResultsController.sections.count;
return(theCount);
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

CFeedEntry *theEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];

theCell.textLabel.text = theEntry.title;

return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

}

#pragma mark -

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
{
[self update];
}

@end

