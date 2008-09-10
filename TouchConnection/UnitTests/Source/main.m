#import <Foundation/Foundation.h>

#import "CPointerArray.h"

int main(int argc, void **argv)
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//

CPointerArray *theArray = [[[CPointerArray alloc] init] autorelease];

NSLog(@"%@", theArray);

[theArray addPointer:@"1"];
[theArray addPointer:@"2"];
[theArray addPointer:@"3"];
[theArray addPointer:@"4"];
[theArray addPointer:@"5"];
[theArray addPointer:@"6"];
[theArray addPointer:@"7"];
[theArray addPointer:@"8"];
[theArray addPointer:@"9"];
[theArray addPointer:@"10"];
[theArray addPointer:@"11"];
[theArray addPointer:@"12"];
[theArray addPointer:@"13"];
[theArray addPointer:@"14"];
[theArray addPointer:@"15"];
[theArray addPointer:@"16"];
[theArray addPointer:@"17"];
[theArray addPointer:@"18"];
[theArray addPointer:@"19"];
[theArray addPointer:@"20"];

for (id theObject in theArray)
	NSLog(@"Object: %@", [theObject description]);


//
[thePool release];
return(0);
}