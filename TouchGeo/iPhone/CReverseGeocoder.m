//
//  CReverseGeocoder.m
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

#import "CReverseGeocoder.h"

#import "CRemoteQueryServer.h"
#import "Beacon.h"
#import "CLLocationManager_Extensions.h"


@interface CReverseGeocoder ()
@property (readwrite, nonatomic, retain) CLLocation *location;
@property (readwrite, nonatomic, retain) CLLocation *lastLocation;
@property (readwrite, nonatomic, retain) CCompletionTicket *completionTicket;
@property (readwrite, nonatomic, retain) NSDictionary *geoplace;
@end

#pragma mark -

static CReverseGeocoder *gInstance = NULL;

@implementation CReverseGeocoder

@dynamic location;
@dynamic locationManager;
@dynamic remoteQueryServer;
@synthesize lastLocation;
@synthesize completionTicket;
@synthesize geoplace;

+ (CReverseGeocoder *)instance
{
@synchronized (self)
	{
	gInstance = [[self alloc] init];
	}
return(gInstance);
}

- (void)dealloc
{
self.locationManager.delegate = NULL;
self.locationManager = NULL;

//NSLog(@"DEALLOC: %@", self);
[self.completionTicket invalidate];
self.completionTicket = NULL;
//
self.geoplace = NULL;
self.remoteQueryServer = NULL;
self.lastLocation = NULL;
self.geoplace = NULL;
//
[super dealloc];
}

#pragma mark -

- (CLLocationManager *)locationManager
{
if (locationManager == NULL)
	{
	NSLog(@"### REVERSE GEOCODER. Creating location manager");
	self.locationManager = [CLLocationManager sharedLocationManager];
	}
return(locationManager); 
}

- (void)setLocationManager:(CLLocationManager *)inLocationManager
{
if (locationManager != inLocationManager)
	{
	if (locationManager != NULL)
		{
		NSLog(@"### REVERSE GEOCODER. Stopping location manager");
		[locationManager stopUpdatingLocation];
		locationManager.delegate = NULL;
		//
		[locationManager release];
		locationManager = NULL;
		}
		
	if (inLocationManager != NULL)
		{
		NSLog(@"### REVERSE GEOCODER. Starting location manager");
		locationManager = [inLocationManager retain];
		locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		locationManager.delegate = self;
		}
    }
}

- (CLLocation *)location
{
NSLog(@"### REVERSE GEOCODER - Location");
#if REVERSE_GEOCODE_FAKE_LOCATION == 1
return([[[CLLocation alloc] initWithLatitude:41.886263 longitude:-87.624469] autorelease]);
#else
return(self.locationManager.location);
#endif /* REVERSE_GEOCODE_FAKE_LOCATION == 1 */
}

- (CRemoteQueryServer *)remoteQueryServer
{
if (remoteQueryServer == NULL)
	{
	self.remoteQueryServer = [[[CRemoteQueryServer alloc] init] autorelease];
	self.remoteQueryServer.rootURL = [NSURL URLWithString:@"http://ws.geonames.org"];
	self.remoteQueryServer.connectionChannelName = @"Reverse Geocoding";
	}
return(remoteQueryServer); 
}

- (void)setRemoteQueryServer:(CRemoteQueryServer *)inRemoteQueryServer
{
if (remoteQueryServer != inRemoteQueryServer)
	{
	[remoteQueryServer release];
	remoteQueryServer = [inRemoteQueryServer retain];
    }
}

#pragma mark -

- (BOOL)fetchGeoplace:(CCompletionTicket *)inCompletionTicket error:(NSError **)outError
{
if (self.completionTicket != NULL)
	{
	if (outError != NULL)
		{
		*outError = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
		}
	return(NO);
	}

self.completionTicket = inCompletionTicket;

[self.locationManager startUpdatingLocation];

return(YES);
}

- (BOOL)fetchGeoplaceForLocation:(CLLocation *)inLocation completionTicket:(CCompletionTicket *)inCompletionTicket error:(NSError **)outError;
{
NSString *theURLString = [NSString stringWithFormat:@"/findNearbyPostalCodesJSON?lat=%g&lng=%g&maxRows=1&style=FULL", inLocation.coordinate.latitude, inLocation.coordinate.longitude];
NSURLRequest *theRequest = [self.remoteQueryServer requestWithRelativeURL:[NSURL URLWithString:theURLString]];

self.completionTicket = [CCompletionTicket completionTicketWithIdentifier:@"Fetch Geoplace" delegate:self userInfo:inLocation subTicket:inCompletionTicket];
[self.remoteQueryServer addQueryWithURLRequest:theRequest completionTicket:self.completionTicket];

return(YES);
}

- (void)cancel
{
//NSLog(@"CANCEL: %@", self);

[self.completionTicket invalidate];
self.completionTicket = NULL;
//
[[self locationManager] stopUpdatingLocation];
[[self remoteQueryServer] cancel];
}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
CLLocation *theLocation = newLocation;
self.lastLocation = theLocation;

#if ENABLE_PINCH_MEDIA_LOCATION == 1
[[Beacon shared] setBeaconLocation:theLocation];
#endif /* ENABLE_PINCH_MEDIA_LOCATION */

if ([theLocation.timestamp timeIntervalSinceNow] <= - 60 * 60)
	{
	NSLog(@"### Location timestamp is too old (%@)", theLocation.timestamp);
	return;
	}

if (theLocation.horizontalAccuracy > self.locationManager.desiredAccuracy)
	{
	NSLog(@"### Location is not accurate enough (%g), discarding.", theLocation.horizontalAccuracy);
	return;
	}

NSLog(@"### REVERSE GEOCODER GOT LOCATION: %@", theLocation);

[self.locationManager stopUpdatingLocation];
	
[self fetchGeoplaceForLocation:theLocation completionTicket:self.completionTicket error:NULL];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
[self.locationManager stopUpdatingLocation];

[self.completionTicket didFailForTarget:self error:error];
}

#pragma mark -

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
NSArray *thePostalCodes = [inResult objectForKey:@"postalCodes"];
if (thePostalCodes == NULL || thePostalCodes.count != 1)
	{
	NSError *theError = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
	[inCompletionTicket.subTicket didFailForTarget:self error:theError];
	return;
	}

NSDictionary *theDictionary = [thePostalCodes objectAtIndex:0];

NSString *theCountryCode = [theDictionary objectForKey:@"countryCode"];
if (theCountryCode == NULL || theCountryCode.length == 0)
	{
	NSError *theError = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
	[inCompletionTicket.subTicket didFailForTarget:self error:theError];
	return;
	}

NSMutableDictionary *theGeoplace = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	theDictionary, @"raw",
	inCompletionTicket.userInfo, @"location",
	[NSDate date], @"timestamp",
	theCountryCode, @"countryCode",
	NULL];
	
NSString *thePostalCode = [theDictionary objectForKey:@"postalCode"];
if (thePostalCode)
	[theGeoplace setObject:thePostalCode forKey:@"postalCode"];

self.geoplace = [[theGeoplace copy] autorelease];

[inCompletionTicket.subTicket didCompleteForTarget:self result:self.geoplace];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didBeginForTarget:(id)inTarget
{
[inCompletionTicket.subTicket didBeginForTarget:inTarget];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didFailForTarget:(id)inTarget error:(NSError *)inError
{
[inCompletionTicket.subTicket didFailForTarget:self error:inError];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCancelForTarget:(id)inTarget
{
[inCompletionTicket.subTicket didCancelForTarget:inTarget];
}

@end
