//
//  CURLConnectionManagerChannel.h
//  TouchCode
//
//  Created by Jonathan Wight on 06/18/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CURLConnectionManager;

/** CURLConnectionManagerChannel is used by CURLConnectionManager to represent a "channel" of active and waiting connections. Generally you do not create these objects yourself, but rely on CURLConnection manager to create them for you. */
@interface CURLConnectionManagerChannel : NSObject {
	CURLConnectionManager *manager;
	NSString *name;
	NSMutableSet *activeConnections;
	NSMutableArray *waitingConnections;
	NSUInteger maximumConnections;
}

@property (readonly, nonatomic, assign) CURLConnectionManager *manager;
@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic, retain) NSMutableSet *activeConnections;
@property (readonly, nonatomic, retain) NSMutableArray *waitingConnections;
@property (readwrite, nonatomic, assign) NSUInteger maximumConnections;

- (id)initWithManager:(CURLConnectionManager *)inManager name:(NSString *)inName;

- (void)cancelAll:(BOOL)inCancelActiveConnections;

@end
