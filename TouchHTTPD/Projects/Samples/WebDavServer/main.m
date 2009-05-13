#import <Cocoa/Cocoa.h>

#import "CTCPSocketListener.h"
#import "CTCPEchoConnection.h"
#import "CHTTPConnection.h"
#import "CNATPMPManager.h"
#import "CWebDavHTTPHandler.h"
#import "CHTTPServer.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool *theAutoreleasePool = [[NSAutoreleasePool alloc] init];

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];

CWebDavHTTPHandler *theRequestHandler = [[[CWebDavHTTPHandler alloc] initWithRootPath:@"/Users/schwa/Sites"] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theRequestHandler];

[theHTTPServer.socketListener start:NULL];

//NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"webdav://%@:%d", [[NSHost currentHost] name], theHTTPServer.socketListener.port]];
//[[NSWorkspace sharedWorkspace] openURL:theURL];

[theHTTPServer.socketListener serveForever:YES error:NULL];

[theAutoreleasePool drain];
return 0;
}
