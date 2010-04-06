//
//  TouchMetricsTestAppDelegate.m
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 10/21/09.
//  Copyright toxicsoftware.com 2009. All rights reserved.
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

