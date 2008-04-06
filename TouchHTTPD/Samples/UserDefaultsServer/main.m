#import <Foundation/Foundation.h>

#import "CTCPSocketListener.h"
#import "CHTTPConnection.h"
#import "CRoutingHTTPRequestHandler.h"
#import "CNATPMPManager.h"
#import "CUserDefaultsHTTPRouter.h"
#import "CUserDefaultsHTTPClient.h"
#import <Foundation/NSDebug.h>
#import "CHTTPServer.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSZombieEnabled = YES;
NSDeallocateZombies = NO;

NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CUserDefaultsHTTPRouter *theRequestHandler = [[[CUserDefaultsHTTPRouter alloc] init] autorelease];
[theRequestHandler.store setValue:@"Hello world" forKey:@"test"];
[theRequestHandler.store setValue:[NSNumber numberWithInt:42] forKey:@"test_int"];
[theRequestHandler.store setValue:[NSNumber numberWithFloat:3.14] forKey:@"test_float"];
[theRequestHandler.store setValue:[NSArray arrayWithObjects:@"a", @"b", @"c", NULL] forKey:@"test_array"];

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];

CUserDefaultsHTTPRouter *theRequestRouter = [[[CUserDefaultsHTTPRouter alloc] init] autorelease];

CRoutingHTTPRequestHandler *theRoutingRequestHandler = [[[CRoutingHTTPRequestHandler alloc] init] autorelease];
theRoutingRequestHandler.router = theRequestRouter;

[theHTTPServer.defaultRequestHandlers addObject:theRoutingRequestHandler];

[theHTTPServer.socketListener start:NULL];

NSInvocationOperation *theServerOperation = [[[NSInvocationOperation alloc] initWithTarget:theHTTPServer.socketListener selector:@selector(serveForever) object:NULL] autorelease];

NSOperationQueue *theQueue = [[[NSOperationQueue alloc] init] autorelease];
[theQueue addOperation:theServerOperation];

NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", [[NSHost currentHost] name], theHTTPServer.socketListener.port]];
[[NSWorkspace sharedWorkspace] openURL:theURL];

[CUserDefaultsHTTPClient standardUserDefaults].host = [NSHost currentHost];
[CUserDefaultsHTTPClient standardUserDefaults].port = theHTTPServer.socketListener.port;

[[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:@"asfasfaf"];


id theInputValue = @"banana";
NSString *theKey = @"KEY";
//NSString *theKey = @"WEIRD/KEY";
[[CUserDefaultsHTTPClient standardUserDefaults] setObject:theInputValue forKey:theKey];
id theOutputValue = [[CUserDefaultsHTTPClient standardUserDefaults] objectForKey:theKey];
NSLog(@"%@", NSStringFromClass([theInputValue class]));
NSLog(@"%@", NSStringFromClass([theOutputValue class]));
NSLog(@"%@ %@", theInputValue, theOutputValue);
NSLog(@"%d", [theInputValue isEqual:theOutputValue]);

sleep(1000);
[pool drain];
return 0;
}

