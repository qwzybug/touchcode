//
//  CLogTableViewController.m
//  Touchcode
//
//  Created by Jonathan Wight on 05/11/09.
//  Copyright 2009 Small Society. All rights reserved.
//

#import "CLogTableViewController.h"

#import "CLogTableViewController.h"
#import "CLogging.h"
#import "CEntityDataSource.h"
#import "CCoreDataManager.h"
#import "CLoggingMessageDetailViewController.h"

@interface CLogTableViewController ()
- (CEntityDataSource *)messageDataSourceForSession:(NSManagedObject *)inSession;
@end

@implementation CLogTableViewController

@synthesize managedObjectContext;
@synthesize sessionsDataSource;
@synthesize messageDataSourcesForSessions;

- (void)dealloc
{
self.sessionsDataSource = NULL;
self.messageDataSourcesForSessions = NULL;
//
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(actionTrash:)] autorelease];

self.managedObjectContext = [CLogging instance].coreDataManager.managedObjectContext;

//
self.sessionsDataSource = [[[CEntityDataSource alloc] initWithManagedObjectContext:self.managedObjectContext entityName:@"LoggingSession"] autorelease];
self.sessionsDataSource.sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO] autorelease]];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
NSManagedObject *theSession = [self.sessionsDataSource.items objectAtIndex:section];
CEntityDataSource *theMessageDataSource = [self messageDataSourceForSession:theSession];
return(theMessageDataSource.items.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
if (theCell == NULL)
	{
	theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
	theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

NSManagedObject *theSession = [self.sessionsDataSource.items objectAtIndex:indexPath.section];
CEntityDataSource *theMessageDataSource = [self messageDataSourceForSession:theSession];
NSManagedObject *theMessage = [theMessageDataSource.items objectAtIndex:indexPath.row];

theCell.textLabel.text = [NSString stringWithFormat:@"%@: %@",
	[CLogging stringForLevel:[[theMessage valueForKey:@"level"] integerValue]],
	[theMessage valueForKey:@"message"]
	];
theCell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@/%@",
	[theMessage valueForKey:@"timestamp"],
	[theMessage valueForKey:@"sender"],
	[theMessage valueForKey:@"facility"]
	];

return(theCell);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
return(self.sessionsDataSource.items.count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
NSString *theTitle = [NSString stringWithFormat:@"%@", [[self.sessionsDataSource.items objectAtIndex:section] valueForKey:@"created"]];

return(theTitle);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
NSManagedObject *theSession = [self.sessionsDataSource.items objectAtIndex:indexPath.section];
CEntityDataSource *theMessageDataSource = [self messageDataSourceForSession:theSession];
NSManagedObject *theMessage = [theMessageDataSource.items objectAtIndex:indexPath.row];

CLoggingMessageDetailViewController *theController = [[[CLoggingMessageDetailViewController alloc] init] autorelease];
theController.message = theMessage;
[self.navigationController pushViewController:theController animated:YES];


return(indexPath);
}

#pragma mark -

- (CEntityDataSource *)messageDataSourceForSession:(NSManagedObject *)inSession
{
CEntityDataSource *theDataSource = [self.messageDataSourcesForSessions objectForKey:inSession];
if (theDataSource == NULL)
	{
	theDataSource = [[[CEntityDataSource alloc] initWithManagedObjectContext:self.managedObjectContext entityName:@"LoggingMessage"] autorelease];
	theDataSource.predicate = [NSPredicate predicateWithFormat:@"session = %@", inSession];
	theDataSource.sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO] autorelease]];

	[self.messageDataSourcesForSessions setObject:theDataSource forKey:inSession];
	}
return(theDataSource);
}

- (IBAction)actionTrash:(id)inSender
{
self.messageDataSourcesForSessions = [NSMutableDictionary dictionary];

for (NSManagedObject *theSession in self.sessionsDataSource.items)
	{
	[self.managedObjectContext deleteObject:theSession];
	}

[self.sessionsDataSource fetch:NULL];

NSError *theError = NULL;
BOOL theResult = [self.managedObjectContext save:&theError];
if (theResult == NO)
	{
	NSLog(@"save: failed %@", theError);
	}
//
[self.tableView reloadData];
}

@end
