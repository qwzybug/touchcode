//
//  CReverseGeocoder.h
//  News
//
//  Created by Jonathan Wight on 9/17/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
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
