//
//  CURLConnectionManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CURLConnectionManager.h"

#import "CURLConnectionManagerChannel.h"

static CURLConnectionManager *gInstance = NULL;

@interface CURLConnectionManager ()

@property (readwrite, nonatomic, assign) BOOL started;
@property (readwrite, nonatomic, retain) NSMutableDictionary *channels;
@property (readwrite, nonatomic, assign) BOOL networkActivity;

@end

#pragma mark -

@implementation CURLConnectionManager

@synthesize started;
@synthesize delegate;
@synthesize channels;
@synthesize networkActivity;

+ (CURLConnectionManager *)instance;
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != nil)
	{
	self.started = NO;
	self.channels = [NSMutableDictionary dictionary];
	//
	[self start];
	}
return(self);
}

- (void)dealloc
{
[self stop];

// TODO cancel all activeConnections?
self.delegate = NULL;
self.channels = NULL;

[super dealloc];
}

- (void)start
{
self.started = YES;
[self processConnections];
}

- (void)stop
{
self.started = NO;
}

#pragma mark -

- (void)addAutomaticURLConnection:(CManagedURLConnection *)inConnection toChannel:(NSString *)inChannel
{
inConnection.manager = self;

CURLConnectionManagerChannel *theChannel = [self.channels objectForKey:inChannel];
if (theChannel == NULL)
	{
	theChannel = [[[CURLConnectionManagerChannel alloc] initWithManager:self name:inChannel] autorelease];
	[self.channels setObject:theChannel forKey:inChannel];
	}
inConnection.channel = inChannel;
[theChannel.waitingConnections insertObject:inConnection atIndex:0];
//
[self processConnections];
}

- (void)processConnections
{
if (self.started == YES)
	{
	NSInteger theTotalActiveConnections = 0;
	
	for (CURLConnectionManagerChannel *theChannel in self.channels.allValues)
		{
		NSUInteger theSpareConnections = MIN(theChannel.maximumConnections - theChannel.activeConnections.count, theChannel.waitingConnections.count);
		if (theSpareConnections > 0)
			{
			for (; theSpareConnections != 0; --theSpareConnections)
				{
				CManagedURLConnection *theConnection = [theChannel.waitingConnections objectAtIndex:0];
				[theChannel.activeConnections addObject:theConnection];
				[theChannel.waitingConnections removeObjectAtIndex:0];
				
				[theConnection start];
				}
			}

		theTotalActiveConnections += theChannel.activeConnections.count;

		self.networkActivity = (theTotalActiveConnections > 0) ? YES : NO;
		}
	}
}

- (CURLConnectionManagerChannel *)channelForName:(NSString *)inName;
{
return([self.channels objectForKey:inName]);
}

#pragma mark -

- (void)connection:(CManagedURLConnection *)inConnection didSucceedWithResponse:(NSURLResponse *)inResponse
{
CURLConnectionManagerChannel *theChannel = [self.channels objectForKey:inConnection.channel];
[theChannel.activeConnections removeObject:inConnection];
//
[self processConnections];
}

- (void)connection:(CManagedURLConnection *)inConnection didFailWithError:(NSError *)inError
{
CURLConnectionManagerChannel *theChannel = [self.channels objectForKey:inConnection.channel];
[theChannel.activeConnections removeObject:inConnection];
//
[self processConnections];
}

- (void)connectionDidCancel:(CManagedURLConnection *)inConnection;
{
CURLConnectionManagerChannel *theChannel = [self.channels objectForKey:inConnection.channel];
[theChannel.activeConnections removeObject:inConnection];
//
[self processConnections];
}

@end

#pragma mark -

@implementation CURLConnectionManager (CURLConnectionManager_ConvenienceMethods)

- (void)addAutomaticURLConnectionForRequest:(NSURLRequest *)inRequest toChannel:(NSString *)inChannel delegate:(id <CManagedURLConnectionDelegate>)inDelegate
{
CManagedURLConnection *theConnection = [[[CManagedURLConnection alloc] initWithRequest:inRequest identifier:NULL delegate:inDelegate userInfo:NULL] autorelease];
[self addAutomaticURLConnection:theConnection toChannel:inChannel];
}

@end