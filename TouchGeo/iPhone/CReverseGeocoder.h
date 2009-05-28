//
//  CReverseGeocoder.h
//  TouchCode
//
//  Created by Jonathan Wight on 9/17/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import "CCompletionTicket.h"

@class CRemoteQueryServer;

@interface CReverseGeocoder : NSObject <CLLocationManagerDelegate, CCompletionTicketDelegate> {
	CLLocationManager *locationManager;
	CRemoteQueryServer *remoteQueryServer;
	CLLocation *lastLocation;
	CLLocation *location;
	CCompletionTicket *completionTicket;
	NSDictionary *geoplace;
}

@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;
@property (readonly, nonatomic, retain) CLLocation *location;
@property (readwrite, nonatomic, retain) CRemoteQueryServer *remoteQueryServer;
@property (readonly, nonatomic, retain) NSDictionary *geoplace;

+ (CReverseGeocoder *)instance;

- (BOOL)fetchGeoplace:(CCompletionTicket *)inCompletionTicket error:(NSError **)outError;

- (BOOL)fetchGeoplaceForLocation:(CLLocation *)inLocation completionTicket:(CCompletionTicket *)inCompletionTicket error:(NSError **)outError;

- (void)cancel;

@end
