//
//  TestAppDelegate.m
//  Test
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "CBonjourBrowserViewController.h"

#import "CLabelledValueTableViewCell.h"
#import "CAccelBroadcasterViewController.h"

@implementation CBonjourBrowserViewController

@synthesize type;
@synthesize domain;
@synthesize browser;
@synthesize services;

- (void)dealloc
{
[super dealloc];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
self.type = @"_accel._udp.";
self.domain = @"";

self.browser = [[[NSNetServiceBrowser alloc] init] autorelease];
self.browser.delegate = self;
//
self.services = [NSMutableArray array];
//
[self.browser searchForServicesOfType:self.type inDomain:self.domain];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
return(2);
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
if (section == 0)
	return(1);
else
	return(self.services.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = NULL;
if (indexPath.section == 0)
	{
	UIActivityIndicatorView *theActivityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	theActivityIndicator.hidesWhenStopped = NO;
	[theActivityIndicator startAnimating];
	
	CLabelledValueTableViewCell *theLabelledCell = [CLabelledValueTableViewCell cell];
	theLabelledCell.text = @"Looking for Services";
	theLabelledCell.valueView = theActivityIndicator;
	theCell = theLabelledCell;
	}
else if (indexPath.section == 1)
	{
	NSNetService *theService = [self.services objectAtIndex:indexPath.row];
	theCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:NULL] autorelease];
	theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	theCell.text = [theService name];
	}
return(theCell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
NSNetService *theService = [self.services objectAtIndex:indexPath.row];
theService.delegate = self;
[theService resolve];
}

#pragma mark -

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
NSLog(@"START");
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
NSLog(@"DONE");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
}

//- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing
//{
//}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
[self.services addObject:aNetService];

[self.tableView reloadData];

NSLog(@"%d", moreComing);
}

//- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing
//{
//}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
[self.services removeObject:aNetService];

[self.tableView reloadData];
}

#pragma mark -

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
CAccelBroadcasterViewController *theController = [[[CAccelBroadcasterViewController alloc] init] autorelease];
theController.service = sender;

[self.navigationController pushViewController:theController animated:YES];



}

@end
