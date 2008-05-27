//
//  CProtocol.h
//  TouchHTTPD
//
//  Created by Jonathan Wight on 04/06/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CProtocol : NSObject {
	CProtocol *lowerLink;
	CProtocol *upperLink; // Weak
}

@property (readwrite, assign) CProtocol *lowerLink;
@property (readwrite, retain) CProtocol *upperLink; // Weak

- (void)close;

- (void)dataReceived:(NSData *)inData;
- (size_t)sendData:(NSData *)inData;

@end
