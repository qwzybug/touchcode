//
//  TestAppDelegate.m
//  Test
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright (c) 2008 Jonathan Wight
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

#import "CBonjourBrowserViewController.h"

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
return(self.services.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
UITableViewCell *theCell = NULL;

NSNetService *theService = [self.services objectAtIndex:indexPath.row];
theCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:NULL] autorelease];
theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
theCell.text = [theService name];

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
