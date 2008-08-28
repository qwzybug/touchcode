//
//  CAccelBroadcasterViewController.h
//  Test
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAccelBroadcasterViewController : UIViewController <UIAccelerometerDelegate> {
	NSNetService *service;
}

@property (readwrite, nonatomic, retain) NSNetService *service;

@end
