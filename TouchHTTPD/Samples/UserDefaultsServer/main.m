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

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];
theHTTPServer.socketListener.type = @"_userdefaults._tcp.";
theHTTPServer.socketListener.port = 0;

CUserDefaultsHTTPRouter *theRequestRouter = [[[CUserDefaultsHTTPRouter alloc] init] autorelease];

CRoutingHTTPRequestHandler *theRoutingRequestHandler = [[[CRoutingHTTPRequestHandler alloc] init] autorelease];
theRoutingRequestHandler.router = theRequestRouter;

[theHTTPServer.defaultRequestHandlers addObject:theRoutingRequestHandler];

[theHTTPServer.socketListener start:NULL];

NSInvocationOperation *theServerOperation = [[[NSInvocationOperation alloc] initWithTarget:theHTTPServer.socketListener selector:@selector(serveForever) object:NULL] autorelease];

NSOperationQueue *theQueue = [[[NSOperationQueue alloc] init] autorelease];
[theQueue addOperation:theServerOperation];

//[CUserDefaultsHTTPClient standardUserDefaults].host = [NSHost currentHost];
//[CUserDefaultsHTTPClient standardUserDefaults].port = theHTTPServer.socketListener.port;

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

