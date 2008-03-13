#import <Foundation/Foundation.h>

#import "CTCPServer.h"
#import "CTCPEchoConnection.h"
#import "CHTTPConnection.h"
#import "CRoutingHTTPConnection.h"
#import "CNATPMPManager.h"
#import "CSampleHTTPHandler.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CSampleHTTPHandler *theRequestHandler = [[[CSampleHTTPHandler alloc] init] autorelease];

CTCPServer *theServer = [[[CTCPServer alloc] init] autorelease];
theServer.delegate = theRequestHandler;
//theServer.port = 8080;
theServer.type = @"_http._tcp.";
//theServer.connectionClass = [CRoutingHTTPConnection class];

NSError *theError;
[theServer start:&theError];

NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d/", [[NSHost currentHost] name], theServer.port]];
[[NSWorkspace sharedWorkspace] openURL:theURL];

CNATPMPManager *theManager = [[[CNATPMPManager alloc] init] autorelease];
[theManager externalAddress:&theError];
[theManager openPortForProtocol:NATPMP_PROTOCOL_TCP privatePort:theServer.port publicPort:theServer.port lifetime:5 * 60 error:&theError];

while (YES)
	{
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}

[pool drain];
return 0;
}
