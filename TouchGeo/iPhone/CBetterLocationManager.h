//
//  CBetterLocationManager.h
//  TouchCode
//
//  Created by Jonathan Wight on 05/06/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#define CBetterLocationManagerDidUpdateToLocationNotification @"CBetterLocationManagerDidUpdateToLocationNotification"

@interface CBetterLocationManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *location;
	BOOL updating;
	NSDate *startedUpdatingAtTime;
	CLLocationDistance stopUpdatingAccuracy;
	NSTimeInterval stopUpdatingAfterInterval;
	NSTimer *timer;
}

@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;
@property(readwrite, nonatomic, assign) CLLocationDistance distanceFilter;
@property(readwrite, nonatomic, assign) CLLocationAccuracy desiredAccuracy;
@property(readonly, nonatomic, retain) CLLocation *location;
@property(readonly, nonatomic, assign) BOOL updating;
@property(readonly, nonatomic, retain) NSDate *startedUpdatingAtTime;
@property(readwrite, nonatomic, assign) CLLocationDistance stopUpdatingAccuracy;
@property(readwrite, nonatomic, assign) NSTimeInterval stopUpdatingAfterInterval;

+ (CBetterLocationManager *)instance;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
