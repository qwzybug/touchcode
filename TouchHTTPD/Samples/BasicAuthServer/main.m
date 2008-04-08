#import <Foundation/Foundation.h>

#import "CHTTPServer.h"
#import "CHelloWorldHTTPHandler.h"
#import "CHTTPBasicAuthHandler.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];

CHelloWorldHTTPHandler *theRequestHandler = [[[CHelloWorldHTTPHandler alloc] init] autorelease];

CHTTPBasicAuthHandler *theAuthHandler = [[[CHTTPBasicAuthHandler alloc] init] autorelease];
theAuthHandler.childHandler = theRequestHandler;
[theHTTPServer.defaultRequestHandlers addObject:theAuthHandler];

[theHTTPServer.socketListener start:NULL];

NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", [[NSHost currentHost] name], theHTTPServer.socketListener.port]];
[[NSWorkspace sharedWorkspace] openURL:theURL];

[theHTTPServer.socketListener serveForever];

[pool drain];
return 0;
}
