//
//  MapToyViewController.h
//  MapToy
//
//  Created by Jonathan Wight on 07/01/08.
//  Copyright toxicsoftware.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMapView;

@interface CMapToyViewController : UIViewController {
	IBOutlet CMapView *outletMapView;
}

@property (readonly, retain) UIScrollView *scrollView;

@end

