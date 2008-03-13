//
//  CQTSnapshot.h
//  TouchHTTP
//
//  Created by Jonathan Wight on 03/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class QTCaptureSession;

@interface CQTCaptureSnapshot : NSObject {
	QTCaptureSession *session;
	CIImage *image;
	NSData *jpegData;
}

@property (readwrite, retain) QTCaptureSession *session;
@property (readwrite, retain) CIImage *image;
@property (readwrite, retain) NSData *jpegData;
	
@end
