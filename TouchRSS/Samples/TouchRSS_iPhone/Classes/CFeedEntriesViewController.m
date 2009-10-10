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

@synthesize feedStore;
@synthesize feed;

- (id)initWithFeedStore:(CFeedStore *)inFeedStore feed:(CFeed *)inFeed;
{
if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
	{
	self.title = inFeed.title;
	//
	self.feedStore = inFeedStore;
	self.feed = inFeed;
	}
return(self);
}

- (void)dealloc
{
self.feedStore = NULL;
self.feed = NULL;
//
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.placeholderLabel.text = @"No entries";
//
[self update];
}

#pragma mark -

- (CFeed *)feed
{
return(feed);
}

- (void)setFeed:(CFeed *)inFeed
{
if (feed != inFeed)
	{
	if (feed)
		{
		[feed release];
		feed = NULL;
		
		self.fetchedResultsController.delegate = NULL;
		self.fetchedResultsController = NULL;
		}
	
	if (inFeed)
		{
		feed = [inFeed retain];
		
		NSEntityDescription *theEntityDescription = [NSEntityDescription entityForName:[CFeedEntry entityName] inManagedObjectContext:self.feedStore.managedObjectContext];
		NSAssert(theEntityDescription != NULL, @"No entity description.");
		NSFetchRequest *theFetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		theFetchRequest.entity = theEntityDescription;
		theFetchRequest.predicate = [NSPredicate predicateWithFormat:@"feed = %@", inFeed];

		NSArray *theSortDescriptors = [NSArray arrayWithObjects:
			[[[NSSortDescriptor alloc] initWithKey:@"updated" ascending:NO] autorelease],
			NULL];
		theFetchRequest.sortDescriptors = theSortDescriptors;

		self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:theFetchRequest managedObjectContext:self.feedStore.managedObjectContext sectionNameKeyPath:NULL cacheName:NULL] autorelease];
		self.fetchedResultsController.delegate = self;
		}
	}
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

