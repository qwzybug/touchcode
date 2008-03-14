//
//  UNATPMPManager.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "natpmp.h"

@interface CNATPMPManager : NSObject {
	natpmp_t natpmp;
	NSData *publicAddress;
}

@property (readwrite, retain) NSData *publicAddress;

- (NSData *)externalAddress:(NSError **)outError;
- (BOOL)openPortForProtocol:(int)protocol privatePort:(int)privateport publicPort:(int)publicport lifetime:(int)lifetime error:(NSError **)outError;

@end
