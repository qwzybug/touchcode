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

@interface CTileManager ()
@property (readwrite, nonatomic, assign) CMap *map;
@property (readwrite, nonatomic, retain) CURLConnectionManager *connectionManager;
@end

@implementation CTileManager

@synthesize map;
@synthesize connectionManager;
@synthesize delegate;

- (id)initWithMap:(CMap *)inMap;
{
if ((self = [super init]) != nil)
	{
	self.map = inMap;
	self.connectionManager = [CURLConnectionManager instance];
	}
return(self);
}

- (void)dealloc
{
self.map = NULL;
self.connectionManager = NULL;
self.delegate = NULL;
//
[super dealloc];
}

- (UIImage *)tileImageForTileIdentifier:(CTileIdentifier *)inTileIdentifier
{
// TODO
//return [self.cache objectForKey:inTileIdentifier];
return(NULL);
}

#pragma mark -

- (NSURL *) URLFromIdentifier:(id)inTileIdentifier {
return [self.map URLForTileIdentifier:inTileIdentifier];
}

//- (void) cacheDidUpdate:(id)cacheKey {
//NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//								 cacheKey, @"tileIdentifier",
//								 NULL];
//	
//[[NSNotificationCenter defaultCenter] postNotificationName:@"CTileManagerReceivedData" object:self userInfo:theUserInfo];
//}

//- (NSData *) cachedObjectSerialize:(id)object {
//return UIImagePNGRepresentation(object);
//}
//
//- (id) cachedObjectDeserialize:(NSData *)object {
//return [UIImage imageWithData:object];
//}

@end
