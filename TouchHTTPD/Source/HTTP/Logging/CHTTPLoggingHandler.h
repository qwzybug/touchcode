//
//  CHTTPLoggingHandler.h
//  WebDAVServer
//
//  Created by Jonathan Wight on 11/13/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CHTTPRequestHandler.h"

@interface CHTTPLoggingHandler : NSObject <CHTTPRequestHandler> {
	NSString *logFile;
	NSFileHandle *fileHandle;
}

@property (readonly, nonatomic, retain) NSString *logFile;
@property (readonly, nonatomic, retain) NSFileHandle *fileHandle;

- (id)initWithLogFile:(NSString *)inLogFile;

- (void)logString:(NSString *)inString;

@end
