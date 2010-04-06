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

NSDictionary *theMessage = [NSDictionary dictionaryWithObjectsAndKeys:
	@"data", @"test",
	NULL];
[[CTouchAnalyticsManager instance] postMessage:theMessage];

CFRunLoopRun();

[pool drain];
return 0;
}
