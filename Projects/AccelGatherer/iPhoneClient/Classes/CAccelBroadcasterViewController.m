//
//  CAccelBroadcasterViewController.m
//  Test
//
//  Created by Jonathan Wight on 8/26/08.
//  Copyright (c) 2008 Jonathan Wight
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
