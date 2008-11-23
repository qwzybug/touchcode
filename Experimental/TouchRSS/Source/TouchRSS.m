#import <Foundation/Foundation.h>

#import "CFeedStore.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CFeedStore *theFeedStore = [[[CFeedStore alloc] init] autorelease];


[pool drain];
return 0;
}



