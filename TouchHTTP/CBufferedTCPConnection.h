//
//  CBufferedTCPConnection.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CTCPConnection.h"

@interface CBufferedTCPConnection : CTCPConnection {
	NSMutableData *inputBuffer;
	NSMutableData *outputBuffer;
}

- (void)dataReceived:(NSData *)inData;
- (void)sendData:(NSData *)inData;

@end
