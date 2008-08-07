//
//  CSecureTransportConnection.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CProtocol.h"

#import <Security/Security.h>

#if TARGET_OS_MAC == 1 && TARGET_OS_IPHONE == 0
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_MAC == 1 && TARGET_OS_IPHONE == 1
#import <CFNetwork/CFNetwork.h>
#endif

@interface CSecureTransportConnection : CProtocol {
	NSArray *certificates;

	SSLContextRef context;
	
	NSMutableData *inputBuffer;
}

@property (readwrite, retain) NSArray *certificates;

@property (readonly, assign) SSLContextRef context;

@end
