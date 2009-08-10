//
//  CBetterLocationManager.m
//  TouchCode
//
//  Created by Jonathan Wight on 05/06/08.
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

#import "CBetterLocationManager.h"

//#define FAKE 1

static CBetterLocationManager *gInstance = NULL;

@interface CBetterLocationManager ()
@property (readwrite, nonatomic, retain) CLLocation *location;
@property (readwrite, nonatomic, assign) BOOL updating;
@property (readwrite, nonatomic, retain) NSDate *startedUpdatingAtTime;
@property (readwrite, nonatomic, assign) NSTimer *timer;

- (void)postNewLocation:(CLLocation *)inNewLocation oldLocation:(CLLocation *)inOldLocation;
@end

@implementation CBetterLocationManager

@synthesize locationManager;
@dynamic distanceFilter;
@dynamic desiredAccuracy;
@synthesize location;
@synthesize updating;
@synthesize startedUpdatingAtTime;
@synthesize stopUpdatingAccuracy;
@dynamic stopUpdatingAfterInterval;
@dynamic timer;

// [[[CLLocation alloc] initWithLatitude:34.5249 longitude:-82.6683] autorelease];

+ (CBetterLocationManager *)instance
{
if (gInstance == NULL)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	self.location = self.locationManager.location;
	self.stopUpdatingAccuracy = kCLLocationAccuracyHundredMeters;
	self.stopUpdatingAfterInterval = 10.0;
	if (self.location)
		[self postNewLocation:self.location oldLocation:NULL];
	}
return(self);
}

- (void)dealloc
{
[self stopUpdatingLocation];

[self.timer invalidate];
self.timer = NULL;

self.locationManager.delegate = NULL;
self.locationManager = NULL;
self.location = NULL;
self.startedUpdatingAtTime = NULL;

[super dealloc];
}

#pragma mark -

- (CLLocationDistance)distanceFilter
{
return(self.locationManager.distanceFilter);
}

- (void)setDistanceFilter:(CLLocationDistance)inDistanceFilter
{
self.locationManager.distanceFilter = inDistanceFilter;
}

- (CLLocationAccuracy)desiredAccuracy
{
return(self.locationManager.desiredAccuracy);
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)inDesiredAccuracy
{
self.locationManager.desiredAccuracy = inDesiredAccuracy;
}

#pragma mark -

- (void)startUpdatingLocation
{
if (self.updating == NO)
	{
	self.startedUpdatingAtTime = [NSDate date];
	self.updating = YES;
	[self.locationManager startUpdatingLocation];
	[[NSNotificationCenter defaultCenter] postNotificationName:CBetterLocationManagerDidStartUpdatingLocationNotification object:self userInfo:NULL];
	if (self.stopUpdatingAfterInterval > 0.0)
		{
		self.timer = [NSTimer scheduledTimerWithTimeInterval:self.stopUpdatingAfterInterval target:self selector:@selector(stopUpdatingTimerDidFire:) userInfo:NULL repeats:NO];	
		}
	}
}

- (void)stopUpdatingLocation
{
if (self.updating == YES)
	{
	[self.locationManager stopUpdatingLocation];
	[[NSNotificationCenter defaultCenter] postNotificationName:CBetterLocationManagerDidStopUpdatingLocationNotification object:self userInfo:NULL];
	self.updating = NO;
	self.timer = NULL;
	}
}

- (NSTimeInterval)stopUpdatingAfterInterval
{
return(stopUpdatingAfterInterval);
}

- (void)setStopUpdatingAfterInterval:(NSTimeInterval)inStopUpdatingAfterInterval
{
stopUpdatingAfterInterval = inStopUpdatingAfterInterval;
if (updating == YES && stopUpdatingAfterInterval > 0.0)
	{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:self.stopUpdatingAfterInterval target:self selector:@selector(stopUpdatingTimerDidFire:) userInfo:NULL repeats:NO];	
	}
}

#pragma mark -

- (NSTimer *)timer
{
return timer; 
}

- (void)setTimer:(NSTimer *)inTimer
{
if (timer != inTimer)
	{
	if (timer != NULL)
		{
		[timer invalidate];
		timer = NULL;
		}

	if (inTimer != NULL)
		{
		timer = inTimer;
		}
    }
}

#pragma mark -

- (void)postNewLocation:(CLLocation *)inNewLocation oldLocation:(CLLocation *)inOldLocation
{
#if ZIPCAR_OPTIONS_USE_FAKE_CORELOCATION == 1
CLLocationCoordinate2D theCoordinate = {
	.latitude = 37.418766,
	.longitude = -122.209774,
	};
inNewLocation = [[[CLLocation alloc] initWithCoordinate:theCoordinate altitude:0 horizontalAccuracy:1000.0 verticalAccuracy:1.0 timestamp:inNewLocation.timestamp] autorelease];
#endif /* ZIPCAR_OPTIONS_USE_FAKE_CORELOCATION == 1 */

self.location = inNewLocation;

NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	inNewLocation, @"NewLocation",
	inOldLocation, @"OldLocation",
	NULL];

if (self.location.horizontalAccuracy <= self.stopUpdatingAccuracy)
	{
	[self stopUpdatingLocation];
	}


[[NSNotificationCenter defaultCenter] postNotificationName:CBetterLocationManagerDidUpdateToLocationNotification object:self userInfo:theUserInfo];
}

#pragma mark -

- (void)stopUpdatingTimerDidFire:(NSTimer *)inTimer
{
if (self.timer == inTimer)
	{
	[self stopUpdatingLocation];
	self.timer = NULL;
	}
}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)inNewLocation fromLocation:(CLLocation *)inOldLocation
{
[self postNewLocation:inNewLocation oldLocation:inOldLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							 error, @"Error",
							 NULL];
[[NSNotificationCenter defaultCenter] postNotificationName:CBetterLocationManagerDidFailWithErrorNotification object:self userInfo:theUserInfo];
}

@end
