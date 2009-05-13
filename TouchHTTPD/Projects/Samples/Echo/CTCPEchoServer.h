//
//  CTCPEchoServer.h
//  Echo
//
//  Created by Jonathan Wight on 12/8/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTCPSocketListener.h"

@class CTCPSocketListener;

@interface CTCPEchoServer : NSObject <CTCPConnectionCreationDelegate> {
	CTCPSocketListener *socketListener;
}

@property (readwrite, retain) CTCPSocketListener *socketListener;


- (void)serve;

@end
