#import <Foundation/Foundation.h>

#import "CTCPServer.h"
#import "CTCPEchoConnection.h"
#import "CHTTPConnection.h"
#import "CRoutingHTTPConnection.h"
#import "CNATPMPManager.h"
#import "CUserDefaultsHTTPHandler.h"
#import "CUserDefaultsHTTPClient.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CUserDefaultsHTTPHandler *theRequestHandler = [[[CUserDefaultsHTTPHandler alloc] init] autorelease];
[theRequestHandler.store setValue:@"Hello world" forKey:@"test"];
[theRequestHandler.store setValue:[NSNumber numberWithInt:42] forKey:@"test_int"];
[theRequestHandler.store setValue:[NSNumber numberWithFloat:3.14] forKey:@"test_float"];
[theRequestHandler.store setValue:[NSArray arrayWithObjects:@"a", @"b", @"c", NULL] forKey:@"test_array"];


CTCPServer *theServer = [[[CTCPServer alloc] init] autorelease];
theServer.delegate = theRequestHandler;
theServer.type = @"_http._tcp.";
theServer.port = 8765;

NSInvocationOperation *theServerOperation = [[[NSInvocationOperation alloc] initWithTarget:theServer selector:@selector(serveForever) object:NULL] autorelease];

NSOperationQueue *theQueue = [[[NSOperationQueue alloc] init] autorelease];
[theQueue addOperation:theServerOperation];

NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", [[NSHost currentHost] name], theServer.port]];
[[NSWorkspace sharedWorkspace] openURL:theURL];

sleep(2);
NSLog(@"RESULT: %@", [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"]);
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:@"banana" forKey:@"test"];
NSLog(@"RESULT: %@", [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test"]);
NSLog(@"RESULT: %@", [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test_float"]);
NSLog(@"RESULT: %@", [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"test_array"]);

sleep(2000);

[pool drain];
return 0;
}
