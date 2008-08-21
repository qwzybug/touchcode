//
//  CURLConnectionManagerChannel.m
//  TouchCode
//
//  Created by Jonathan Wight on 06/18/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CURLConnectionManagerChannel.h"

#import "CURLConnectionManager.h"

@interface CURLConnectionManagerChannel ()
@property (readwrite, nonatomic, assign) CURLConnectionManager *manager;
@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic, retain) NSMutableSet *activeConnections;
@property (readwrite, nonatomic, retain) NSMutableArray *waitingConnections;
@end

#pragma mark -

@implementation CURLConnectionManagerChannel

@synthesize manager;
@synthesize name;
@synthesize activeConnections;
@synthesize waitingConnections;
@dynamic maximumConnections;

- (id)initWithManager:(CURLConnectionManager *)inManager name:(NSString *)inName
{
if ((self = [super init]) != NULL)
	{
	self.manager = inManager;
	self.name = inName;
	self.activeConnections = [NSMutableSet set];
	self.waitingConnections = [NSMutableArray array];
	self.maximumConnections = 4;
	}
return(self);
}

- (void)dealloc
{
self.manager = NULL;
self.name = NULL;
self.activeConnections = NULL;
self.waitingConnections = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSUInteger)maximumConnections
{
return(maximumConnections);
}

- (void)setMaximumConnections:(NSUInteger)inMaximumConnections
{
if (maximumConnections != inMaximumConnections)
	{
	maximumConnections = inMaximumConnections;
	//
	[self.manager processConnections];
	}
}

- (void)cancelAll:(BOOL)inCancelActiveConnections
{
// Cancel all waiting connections.
for (CManagedURLConnection *theConnection in [[self.waitingConnections copy] autorelease])
	{
	[theConnection cancel];
	[self.waitingConnections removeObject:theConnection];
	}

if (inCancelActiveConnections)
	{
	for (CManagedURLConnection *theConnection in [[self.activeConnections copy] autorelease])
		{
		[theConnection cancel];
		[self.waitingConnections removeObject:theConnection];
		}
	}
}

@end
