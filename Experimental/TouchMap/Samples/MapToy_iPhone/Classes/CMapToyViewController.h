//
//  MapToyViewController.h
//  MapToy
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMap;
@class CMapView;

@interface CMapToyViewController : UIViewController {
	CMap *map;
	
	IBOutlet CMapView *outletMapView;
}

@property (readwrite, retain) CMap *map;
@property (readwrite, retain) CMapView *mapView;

- (IBAction)actionMapStyle1:(id)inSender;
- (IBAction)actionMapStyle2:(id)inSender;
- (IBAction)actionMapStyle3:(id)inSender;
- (IBAction)actionMapStyle4:(id)inSender;

- (IBAction)actionLocate:(id)inSender;

@end

