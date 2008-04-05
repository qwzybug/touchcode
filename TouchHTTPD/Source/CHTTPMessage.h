//
//  CHTTPMessage.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CHTTPMessage : NSObject {
	CFHTTPMessageRef message;
}

@property (readwrite, assign) CFHTTPMessageRef message;


@end
