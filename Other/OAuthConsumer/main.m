#import <Foundation/Foundation.h>

#import "OAHMAC_SHA1SignatureProvider.h"

int main(int argc, char **argv)
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];


OAHMAC_SHA1SignatureProvider *provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
NSLog(@"%@", [provider signClearText:@"simon says" withSecret:@"abcedfg123456789"]);


[thePool release];
return(0);
}