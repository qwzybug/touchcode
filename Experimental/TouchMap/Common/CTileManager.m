//
//  CTileManager.m
//  VIrtualEarth
//
//  Created by Jonathan Wight on 04/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CTileManager.h"

#import "CMap.h"
#import "CTileIdentifier.h"
#import "CLazyCache.h"

@interface CTileManager ()
@property (readwrite, nonatomic, assign) CMap *map;
@property (readwrite, nonatomic, retain) CURLConnectionManager *connectionManager;
@property (readwrite, nonatomic, retain) CLazyCache *cache;

- (NSURL *)URLFromIdentifier:(id)inTileIdentifier;

@end

@implementation CTileManager

@synthesize map;
@synthesize connectionManager;
@synthesize delegate;
@synthesize cache;
@synthesize enableDownloads;

- (id)initWithMap:(CMap *)inMap;
{
if ((self = [super init]) != nil)
	{
	self.map = inMap;
	self.connectionManager = [CURLConnectionManager instance];
	self.cache = [[[CLazyCache alloc] initWithCapacity:100] autorelease];
	self.enableDownloads = YES;
	}
return(self);
}

- (void)dealloc
{
self.map = NULL;
self.connectionManager = NULL;
self.delegate = NULL;
self.cache = NULL;
//
[super dealloc];
}

- (UIImage *)tileImageForTileIdentifier:(CTileIdentifier *)inTileIdentifier
{
NSURL *theURL = [self URLFromIdentifier:inTileIdentifier];
UIImage *theImage = [self.cache cachedObjectForKey:theURL];
if (theImage == NULL && self.enableDownloads == YES)
	{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	
	CCompletionTicket *theTicket = [CCompletionTicket completionTicketWithIdentifier:NULL delegate:self userInfo:inTileIdentifier];
	
	CManagedURLConnection *theConnection = [[[CManagedURLConnection alloc] initWithRequest:theRequest completionTicket:theTicket] autorelease];
	
	[self.connectionManager addAutomaticURLConnection:theConnection toChannel:@"tiles"];
	}
return(theImage);
}

#pragma mark -

- (NSURL *)URLFromIdentifier:(id)inTileIdentifier
{
return([self.map URLForTileIdentifier:inTileIdentifier]);
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult;
{
CManagedURLConnection *theManagedURLConnection = (CManagedURLConnection *)inTarget;
CTileIdentifier *theTileIdentifier = inCompletionTicket.userInfo;
NSURL *theURL = [self URLFromIdentifier:theTileIdentifier];
UIImage *theImage = [UIImage imageWithData:theManagedURLConnection.data];

[self.cache cacheObject:theImage forKey:theURL];

if (self.enableDownloads == NO)
	return;

NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	theTileIdentifier, @"tileIdentifier",
	NULL];

[[NSNotificationCenter defaultCenter] postNotificationName:@"CTileManagerReceivedData" object:self userInfo:theUserInfo];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError
{
NSLog(@"FAIL");
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget
{
NSLog(@"CANCEL");
}

@end
