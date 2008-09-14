//
//  LocationLookupDemoViewController.m
//  LocationLookupDemo
//
//  Created by Jonathan Wight on 9/14/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import "LocationLookupDemoViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "CRemoteQueryServer.h"

@implementation LocationLookupDemoViewController

@synthesize locationManager;
@synthesize queryServer;

- (IBAction)actionLookup:(id)inSender
{
if (self.locationManager == NULL)
	{
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	}

[self.locationManager startUpdatingLocation];
// http://ws.geonames.org/findNearestAddressJSON?lat=37.451&lng=-122.18
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
NSLog(@"Location");

[self.locationManager stopUpdatingLocation];

if (self.queryServer == NULL)
	{
	self.queryServer = [[[CRemoteQueryServer alloc] init] autorelease];
	self.queryServer.rootURL = [NSURL URLWithString:@"http://ws.geonames.org"];
	}

NSString *theURLString = [NSString stringWithFormat:@"/findNearestAddressJSON?lat=%g&lng=%g", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
NSURLRequest *theRequest = [self.queryServer requestWithRelativeURL:[NSURL URLWithString:theURLString]];

CCompletionTicket *theTicket = [CCompletionTicket completionTicketWithIdentifier:@"foo" delegate:self userInfo:NULL];

[self.queryServer addQueryWithURLRequest:theRequest completionTicket:theTicket];
}

- (void)completionTicket:(CCompletionTicket *)inCompletionTicket didCompleteForTarget:(id)inTarget result:(id)inResult
{
NSLog(@"COMPLETE: %@", inResult);

outletTextView.text = [inResult description];

//address =     {
//        adminCode1 = CA;
//        adminCode2 = 085;
//        adminName1 = California;
//        adminName2 = "Santa Clara";
//        countryCode = US;
//        distance = "0.05";
//        lat = "37.3317";
//        lng = "-122.031548";
//        placename = Cupertino;
//        postalcode = 00;
//        street = "Infinite Loop";
//        streetNumber = "";
//    };


}

@end
