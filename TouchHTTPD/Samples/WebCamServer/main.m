#import <Foundation/Foundation.h>

#import "CTCPSocketListener.h"
#import "CTCPEchoConnection.h"
#import "CHTTPConnection.h"
#import "CRoutingHTTPRequestHandler.h"
#import "CNATPMPManager.h"
#import "CHTTPServer.h"
#import "CWebcamHTTPRouter.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];

CWebcamHTTPRouter *theRequestRouter = [[[CWebcamHTTPRouter alloc] init] autorelease];

CRoutingHTTPRequestHandler *theRoutingRequestHandler = [[[CRoutingHTTPRequestHandler alloc] init] autorelease];
theRoutingRequestHandler.router = theRequestRouter;


[theHTTPServer.defaultRequestHandlers addObject:theRoutingRequestHandler];

[theHTTPServer.socketListener start:NULL];

NSError *theError = NULL;
CNATPMPManager *theManager = [[[CNATPMPManager alloc] init] autorelease];
[theManager externalAddress:&theError];
[theManager openPortForProtocol:NATPMP_PROTOCOL_TCP privatePort:theHTTPServer.socketListener.port publicPort:theHTTPServer.socketListener.port lifetime:5 * 60 error:&theError];

NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", [[NSHost currentHost] name], theHTTPServer.socketListener.port]];
[[NSWorkspace sharedWorkspace] openURL:theURL];

[theHTTPServer.socketListener serveForever];

[pool drain];
return 0;
}
