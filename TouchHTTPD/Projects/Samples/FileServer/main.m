#import <Cocoa/Cocoa.h>

#import "CTCPSocketListener.h"
#import "CTCPSocketListener_Extensions.h"
#import "CHTTPConnection.h"
#import "CHTTPFileSystemHandler.h"
#import "CHTTPServer.h"
#import "CWebDavHTTPHandler.h"
#import "CHTTPStaticResourcesHandler.h"
#import "CHTTPDefaultHandler.h"
#import "CHTTPLogHandler.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool *theAutoreleasePool = [[NSAutoreleasePool alloc] init];

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];

CHTTPFileSystemHandler *theRequestHandler = [[[CWebDavHTTPHandler alloc] initWithRootPath:@"/Users/schwa/Sites/Test"] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theRequestHandler];

CHTTPStaticResourcesHandler *theStaticResourceHandler = [[[CHTTPStaticResourcesHandler alloc] init] autorelease];
theStaticResourceHandler.rootDirectory = [@"~/Sites/static" stringByExpandingTildeInPath];
[theHTTPServer.defaultRequestHandlers addObject:theStaticResourceHandler];

CHTTPDefaultHandler *theDefaultHandler = [[[CHTTPDefaultHandler alloc] init] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theDefaultHandler];

CHTTPLogHandler *theLogHandler = [[[CHTTPLogHandler alloc] init] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theLogHandler];


[theHTTPServer.socketListener start:NULL];

//NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"webdav://%@:%d", [[NSHost currentHost] name], theHTTPServer.socketListener.port]];
//[[NSWorkspace sharedWorkspace] openURL:theURL];

[theHTTPServer.socketListener serveForever:YES error:NULL];

[theAutoreleasePool drain];
return 0;
}
