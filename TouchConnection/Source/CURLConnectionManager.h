//
//  CURLConnectionManager.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CManagedURLConnection.h"

@class CURLConnectionManagerChannel;

@interface CURLConnectionManager : NSObject <CManagedURLConnectionDelegate> {
	BOOL started;
	
	NSMutableDictionary *channels;
	BOOL networkActivity;
}

@property (readonly, nonatomic, assign) BOOL started;
@property (readonly, nonatomic, assign) BOOL networkActivity;

+ (CURLConnectionManager *)instance;

- (void)start;
- (void)stop;

- (void)addAutomaticURLConnection:(CManagedURLConnection *)inConnection toChannel:(NSString *)inChannel;

- (void)processConnections;

- (CURLConnectionManagerChannel *)channelForName:(NSString *)inName;

@end

#pragma mark -

@interface CURLConnectionManager (CURLConnectionManager_ConvenienceMethods)

- (void)addAutomaticURLConnectionForRequest:(NSURLRequest *)inRequest toChannel:(NSString *)inChannel delegate:(id <CManagedURLConnectionDelegate>)inDelegate;

@end