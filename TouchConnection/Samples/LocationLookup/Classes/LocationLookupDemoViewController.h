//
//  LocationLookupDemoViewController.h
//  LocationLookupDemo
//
//  Created by Jonathan Wight on 9/14/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "CCompletionTicket.h"

@class CRemoteQueryServer;

@interface LocationLookupDemoViewController : UIViewController <CLLocationManagerDelegate, CCompletionTicketDelegate> {
	CLLocationManager *locationManager;
	CRemoteQueryServer *queryServer;
	IBOutlet UITextView *outletTextView;
}

@property (readwrite, nonatomic, retain) CLLocationManager *locationManager;
@property (readwrite, nonatomic, retain) CRemoteQueryServer *queryServer;

- (IBAction)actionLookup:(id)inSender;

@end

