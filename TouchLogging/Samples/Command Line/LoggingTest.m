#import <Foundation/Foundation.h>

//#import "CLoggingUploaderOperation.h"

#import "NSOperationQueue_Extensions.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

LogDebug_(@"Ooops");

//
////CLoggingUploaderOperation *theUploaderOperation = [[[CLoggingUploaderOperation alloc] init] autorelease];
//
//NSOperationQueue *theQueue = [[[NSOperationQueue alloc] init] autorelease];
////[theQueue setSuspended:YES];
//[theQueue addOperationRecursively:theUploaderOperation];
//[theUploaderOperation dump];
//
//while (theQueue.operations.count > 0)
//	{
//	NSLog(@"LOOP");
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
//	}
//

[pool drain];
return 0;
}
