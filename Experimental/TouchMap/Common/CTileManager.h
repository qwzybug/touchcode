//
//  CTileManager.h
//  TouchCode
//
//  Created by Jonathan Wight on 04/23/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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

#import <Foundation/Foundation.h>

#import "CURLConnectionManager.h"
#import "CCompletionTicket.h"

@protocol CTileManagerDelegate;

@class CMap;
@class CTileIdentifier;
@class CLazyCache;

@interface CTileManager : NSObject <CCompletionTicketDelegate> {
	CMap *map;
	CURLConnectionManager *connectionManager;
	id <CTileManagerDelegate> delegate;
	CLazyCache *cache;
	BOOL enableDownloads;
}

@property (readonly, nonatomic, assign) CMap *map;
@property (readonly, nonatomic, retain) CURLConnectionManager *connectionManager;
@property (readwrite, nonatomic, retain) id <CTileManagerDelegate> delegate;
@property (readonly, nonatomic, retain) CLazyCache *cache;
@property (readwrite, nonatomic, assign) BOOL enableDownloads;

- (id)initWithMap:(CMap *)inMap;

- (UIImage *)tileImageForTileIdentifier:(CTileIdentifier *)inTileIdentifier;

@end

#pragma mark -

@protocol CTileManagerDelegate <NSObject>

- (void)tileManager:(CTileManager *)inTileManager didReceiveData:(NSData *)inData forTileIdentifier:(NSString *)inTileIdentifier;

@end
