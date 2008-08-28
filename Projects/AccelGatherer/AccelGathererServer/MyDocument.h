//
//  MyDocument.h
//  AccelGathererServer
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright toxicsoftware.com 2008 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Quartz/Quartz.h>

@interface MyDocument : NSPersistentDocument {
	NSInteger port;
	CFSocketRef socket;
	NSNetService *service;
	NSDate *firstDate;
	
	IBOutlet NSArrayController *outletArrayController;
	IBOutlet QCView *outletQCView;
}

@property (readwrite, assign) NSInteger port;
@property (readwrite, assign) CFSocketRef socket;
@property (readwrite, retain) NSNetService *service;
@property (readwrite, retain) NSDate *firstDate;
@property (readwrite, retain) NSArrayController *arrayController;

- (BOOL)startPublishing:(NSError **)outError;
- (BOOL)startServing:(NSError **)outError;

@end
