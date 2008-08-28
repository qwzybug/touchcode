//
//  CAccelBroadcasterViewController.m
//  Test
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CAccelBroadcasterViewController.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

static void MyCFSocketCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@implementation CAccelBroadcasterViewController

@synthesize service;

- (void)loadView
{
[super loadView];
//
self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 490)] autorelease];
}

- (void)viewDidLoad
{
[super viewDidLoad];
//
[UIAccelerometer sharedAccelerometer].delegate = self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
NSString *theText = [NSString stringWithFormat:@"%g,%g,%g,%g", acceleration.timestamp, acceleration.x, acceleration.y, acceleration.z];
NSLog(@"%@", theText);

NSData *theData = [theText dataUsingEncoding:NSASCIIStringEncoding];
NSData *theAddress = [self.service.addresses objectAtIndex:0];

NSLog(@"%@", theAddress);
CFSocketRef theSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketNoCallBack, NULL, NULL);
NSLog(@"%@", theSocket);
CFSocketError theError = CFSocketSendData(theSocket, (CFDataRef)theAddress, (CFDataRef)theData, 1.0);
NSLog(@"%d", theError);


CFRelease(theSocket);



}

@end
