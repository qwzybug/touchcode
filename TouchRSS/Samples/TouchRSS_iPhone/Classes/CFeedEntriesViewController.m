//
//  CFeedEntriesViewController.m
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
UILabel *thePlaceholderLabel = (UILabel *)self.placeholderView;
thePlaceholderLabel.text = @"No entries";
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

@end

