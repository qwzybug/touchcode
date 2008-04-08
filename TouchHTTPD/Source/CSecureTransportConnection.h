//
//  CSecureTransportConnection.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/07/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CProtocol.h"

#import <Security/Security.h>

@interface CSecureTransportConnection : CProtocol {
	NSArray *certificates;

	SSLContextRef context;
	
	NSMutableData *inputBuffer;
}

@property (readwrite, retain) NSArray *certificates;

@property (readonly, assign) SSLContextRef context;

@end
