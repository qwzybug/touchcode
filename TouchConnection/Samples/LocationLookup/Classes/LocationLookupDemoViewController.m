//
//  LocationLookupDemoViewController.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/14/08.
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
