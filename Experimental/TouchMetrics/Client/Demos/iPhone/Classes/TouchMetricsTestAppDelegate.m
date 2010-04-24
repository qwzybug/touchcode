//
//  TouchMetricsTestAppDelegate.m
//  TouchCode
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright 2009 toxicsoftware.com. All rights reserved.
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

#import "TouchMetricsTestAppDelegate.h"

#import "NSData_HMACExtensions.h"
#import "NSData_Extensions.h"
#import "CPersistentRequestManager.h"
#import "CTouchAnalyticsManager.h"

@implementation TouchMetricsTestAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize imagePickerController;
@synthesize requestManager;

- (void)dealloc
{
[window release];
window = NULL;
[viewController release];
viewController = NULL;
[imagePickerController release];
imagePickerController = NULL;
//
[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
[window addSubview:self.viewController.view];
[window makeKeyAndVisible];

self.requestManager = [[[CPersistentRequestManager alloc] init] autorelease];

//NSDictionary *theMessage = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"test", NULL];
//[[CTouchAnalyticsManager instance] postMessage:theMessage];

#if 1
self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
self.imagePickerController.delegate = self;
self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

[self.viewController presentModalViewController:self.imagePickerController animated:YES];
#endif
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
UIImage *theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
NSData *theContent = UIImagePNGRepresentation(theImage);


NSData *theKey = [@"sekret" dataUsingEncoding:NSUTF8StringEncoding];
//NSURL *theURL = [NSURL URLWithString:@"http://localhost:8080/api/0/upload"];
//NSURL *theURL = [NSURL URLWithString:@"http://cobweb.local.:8080/api/0/upload"];
NSURL *theURL = [NSURL URLWithString:@"http://filer.appspot.com/api/0/upload"];
NSString *theServiceIdentifier = @"test";
NSString *theContentType = @"image/png";
NSData *theDigest = [theContent HMACDigestWithKey:theKey];
NSString *theHexDigest = [theDigest hexString];


//NSLog(@"%d", strlen(theDigest));

NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
[theRequest setHTTPMethod:@"POST"];
[theRequest setValue:theContentType forHTTPHeaderField:@"Content-Type"];
[theRequest setValue:theHexDigest forHTTPHeaderField:@"x-hmac-body-hexdigest"];
[theRequest setValue:theServiceIdentifier forHTTPHeaderField:@"x-service-identifier"];

theRequest.HTTPBody = theContent;


[self.requestManager addRequest:theRequest];

[self.viewController dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
[self.viewController dismissModalViewControllerAnimated:YES];
}

@end

