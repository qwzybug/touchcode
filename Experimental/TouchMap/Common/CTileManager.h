//
//  CTileManager.h
//  VIrtualEarth
//
//  Created by Jonathan Wight on 04/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CURLConnectionManager.h"

@protocol CTileManagerDelegate;

@class CMap;
@class CTileIdentifier;

@interface CTileManager : NSObject {
	CMap *map;
	CURLConnectionManager *connectionManager;
	id <CTileManagerDelegate> delegate;
}

@property (readonly, nonatomic, assign) CMap *map;
@property (readonly, nonatomic, retain) CURLConnectionManager *connectionManager;
@property (readwrite, nonatomic, retain) id <CTileManagerDelegate> delegate;

- (id)initWithMap:(CMap *)inMap;

- (UIImage *)tileImageForTileIdentifier:(CTileIdentifier *)inTileIdentifier;

@end

#pragma mark -

@protocol CTileManagerDelegate <NSObject>

- (void)tileManager:(CTileManager *)inTileManager didReceiveData:(NSData *)inData forTileIdentifier:(NSString *)inTileIdentifier;

@end
