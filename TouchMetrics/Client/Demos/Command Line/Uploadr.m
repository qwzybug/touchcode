#import <Foundation/Foundation.h>

#import "NSData_Extensions.h"
#import "NSData_HMACExtensions.h"
#import "CURLOperation.h"
#import "NSOperationQueue_Extensions.h"
#import "CTemporaryData.h"
#import "CPersistentRequestManager.h"
#import "CTouchAnalyticsManager.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

//NSData *theKey = [@"sekret" dataUsingEncoding:NSUTF8StringEncoding];
//NSURL *theURL = [NSURL URLWithString:@"http://localhost:8080/api/0/upload"];
//NSString *theServiceIdentifier = @"test";
//NSString *theContentType = @"text/plain";
//NSData *theContent = [@"Hello World (from Foundation)" dataUsingEncoding:NSUTF8StringEncoding];
//NSData *theDigest = [theContent HMACDigestWithKey:theKey];
//NSString *theHexDigest = [theDigest hexString];
//NSLog(@"%@", theHexDigest);
//
////NSLog(@"%d", strlen(theDigest));
//
//NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
//[theRequest setHTTPMethod:@"POST"];
//[theRequest setValue:theContentType forHTTPHeaderField:@"Content-Type"];
//[theRequest setValue:theHexDigest forHTTPHeaderField:@"x-hmac-body-hexdigest"];
//[theRequest setValue:theServiceIdentifier forHTTPHeaderField:@"x-service-identifier"];
//
//theRequest.HTTPBody = theContent;

//CPersistentRequestManager *theManager = [[[CPersistentRequestManager alloc] init] autorelease];
//[theManager addRequest:theRequest];

NSDictionary *theMessage = [NSDictionary dictionaryWithObjectsAndKeys:
	@"data", @"test",
	NULL];
[[CTouchAnalyticsManager instance] postMessage:theMessage];


CFRunLoopRun();

//NSHTTPURLResponse *theResponse = (NSHTTPURLResponse *)theOperation.response;
//NSError *theError = theOperation.error;
//NSData *theResponseData = theOperation.data;
////
//NSLog(@"RESPONSE: %d", theResponse.statusCode);
//NSLog(@"ERROR: %@", theError);
//NSLog(@"DATA: %@", [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease]);

[pool drain];
return 0;
}
