#import <Foundation/Foundation.h>
#import <Foundation/NSDebug.h>

#import "CTCPEchoServer.h"

static void serve(void);

int main(int argc, const char * argv[])
{
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

NSDebugEnabled = YES;
NSZombieEnabled = YES;

serve();

[pool drain];
return 0;
}

static void serve(void)
{
CTCPEchoServer *theServer = [[[CTCPEchoServer alloc] init] autorelease];
[theServer serve];
}